//
//  SubscriptionRequests.swift
//  Asthm App
//
//  Created by Den Matiash on 23.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import StoreKit
import common

fileprivate let monthlySubscription = "monthly_subscription"

class SubscriptionRequests {

    class FetchSubscriptions: ISubscriptionRequestsFetchSubscriptions {

        private static let KEY_EXPIRATION_DATE = "key_expiration_date"

        override func execute() {
            if let expirationDate = UserDefaults.standard.object(forKey: FetchSubscriptions.KEY_EXPIRATION_DATE) as? Date, expirationDate > Date() {
                store.dispatch(action: ISubscriptionRequestsFetchSubscriptions.Success())
                return
            }

            guard let receiptURL = Bundle.main.appStoreReceiptURL,
                  FileManager.default.fileExists(atPath: receiptURL.path),
                  let receiptData = try? Data(contentsOf: receiptURL).base64EncodedString(),
                  let appleServer = receiptURL.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy",
                  let serverUrl = URL(string: "https://\(appleServer).itunes.apple.com/verifyReceipt") else {
                store.dispatch(action: ISubscriptionRequestsFetchSubscriptions.Failure())
                return
            }

            verifyReceipt(receiptData: receiptData, serverUrl: serverUrl)
        }

        private func verifyReceipt(receiptData: String, serverUrl: URL) {
            let requestData: [String: Any] = [
                "receipt-data": receiptData,
                "password": "a094d4605e094eeb8f9a8d3923f7c23f"
            ]

            var request = URLRequest(url: serverUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard data != nil,
                          let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments),
                          let dictionary = json as? Dictionary<String, Any>,
                          let receipts = dictionary["latest_receipt_info"] as? [Dictionary<String, Any>] else {
                        store.dispatch(action: ISubscriptionRequestsFetchSubscriptions.Failure())
                        return
                    }

                    var maxExpirationDate = Date()
                    let formatter = DateFormatter().apply { $0.dateFormat = "yyyy-MM-dd HH:mm:ss VV" }

                    for receipt in receipts {
                        if let expirationDate = formatter.date(from: receipt["expires_date"] as! String), expirationDate > maxExpirationDate {
                            maxExpirationDate = expirationDate
                        }
                    }

                    UserDefaults.standard.set(maxExpirationDate, forKey: FetchSubscriptions.KEY_EXPIRATION_DATE)

                    if maxExpirationDate > Date() {
                        store.dispatch(action: ISubscriptionRequestsFetchSubscriptions.Success())
                    } else {
                        store.dispatch(action: ISubscriptionRequestsFetchSubscriptions.Failure())
                    }
                }
            }.resume()
        }
    }

    class FetchSkuDetails: ISubscriptionRequestsFetchSkuDetails {

        private let delegate = MySKProductsRequestDelegate()

        private lazy var productRequest = SKProductsRequest(
            productIdentifiers: Set([monthlySubscription])
        ).apply {
            $0.delegate = delegate
        }

        override func execute() { productRequest.start() }

        private class MySKProductsRequestDelegate: NSObject, SKProductsRequestDelegate {

            func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
                DispatchQueue.main.async {
                    let monthlySku = response.products.first { product in
                        product.productIdentifier == monthlySubscription
                    }

                    if let monthlySku = monthlySku {
                        store.dispatch(action: ISubscriptionRequestsFetchSkuDetails.Success(
                            monthlySku: monthlySku.map(months: 1.0)
                        ))
                    } else {
                        store.dispatch(action: ISubscriptionRequestsFetchSkuDetails.Failure())
                    }
                }
            }
        }
    }

    class LaunchBillingFlow: ISubscriptionRequestsLaunchBillingFlow {

        private let delegate = MySKPaymentTransactionObserver()

        private let sku: Sku

        init(sku: Sku) {
            self.sku = sku
        }

        override func execute() {
            SKPaymentQueue.default().add(delegate)
            launchBillingFlow()
        }

        private func launchBillingFlow() {
            let product = sku.details as! SKProduct
            let payment = SKMutablePayment(product: product)
            SKPaymentQueue.default().add(payment)
        }

        private class MySKPaymentTransactionObserver: NSObject, SKPaymentTransactionObserver {

            func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
                for transaction in transactions {
                    switch transaction.transactionState {
                    case .purchasing: break
                    case .deferred: break
                    case .purchased, .restored: handlePurchased(transaction)
                    case .failed: handleFailed(transaction)
                    @unknown default: fatalError("Unknown state")
                    }
                }
            }

            private func handlePurchased(_ transaction: SKPaymentTransaction) {
                store.dispatch(action: ISubscriptionRequestsLaunchBillingFlow.Success())
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            }

            private func handleFailed(_ transaction: SKPaymentTransaction) {
                store.dispatch(action: ISubscriptionRequestsLaunchBillingFlow.Failure())
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            }
        }
    }
}

fileprivate extension SKProduct {

    var regularPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }

    func map(months: Double) -> Sku {
        Sku(
            id: productIdentifier,
            currency: priceLocale.currencySymbol!,
            monthlyPrice: price.doubleValue / months,
            details: self
        )
    }
}

fileprivate extension Date {

    func expiration(of sku: String?) -> Date? {
        Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
}
