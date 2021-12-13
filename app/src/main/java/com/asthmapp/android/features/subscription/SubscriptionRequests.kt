package com.asthmapp.android.features.subscription

import android.app.Activity
import com.android.billingclient.api.*
import com.asthmapp.android.appContext
import com.asthmapp.features.subscription.ISubscriptionRequests
import com.asthmapp.features.subscription.Sku
import com.asthmapp.redux.store

class SubscriptionRequests : ISubscriptionRequests {

    class FetchSubscriptions : ISubscriptionRequests.FetchSubscriptions() {

        private val billingClient = BillingClient.newBuilder(appContext)
                .enablePendingPurchases()
                .setListener { _, _ -> }
                .build()

        override fun execute() = billingClient.start(
                onSuccess = { fetchSubscriptions() },
                onFailure = {
                    store.dispatch(Failure)
                    billingClient.endConnection()
                }
        )

        private fun fetchSubscriptions() {
            val result = billingClient.queryPurchases(BillingClient.SkuType.SUBS)
            if (result.purchasesList.none { it.isAcknowledged }) {
                store.dispatch(Failure)
            } else {
                store.dispatch(Success)
            }

            billingClient.endConnection()
        }
    }

    class FetchSkuDetails : ISubscriptionRequests.FetchSkuDetails() {

        private val billingClient = BillingClient.newBuilder(appContext)
                .enablePendingPurchases()
                .setListener { _, _ -> }
                .build()

        override fun execute() = billingClient.start(
                onSuccess = { fetchSkuDetails() },
                onFailure = {
                    store.dispatch(Failure)
                    billingClient.endConnection()
                }
        )

        private fun fetchSkuDetails() {
            val params = SkuDetailsParams.newBuilder()
                    .setSkusList(listOf(SKU_MONTHLY_SUBSCRIPTION))
                    .setType(BillingClient.SkuType.SUBS)
                    .build()

            billingClient.querySkuDetailsAsync(params) { billingResult, skuDetails ->
                val response = when (billingResult.responseCode) {
                    BillingClient.BillingResponseCode.OK -> {
                        val skuMap = skuDetails.associateBy { it.sku }
                        val skuMonthly = skuMap[SKU_MONTHLY_SUBSCRIPTION]

                        if (skuMonthly == null) {
                            Failure
                        } else {
                            Success(skuMonthly.map(months = 1))
                        }
                    }
                    else -> Failure
                }

                store.dispatch(response)
                billingClient.endConnection()
            }
        }

        private fun SkuDetails.map(months: Int) = Sku(
                id = sku,
                monthlyPrice = priceAmountMicros / months / 1_000_000.0,
                details = this,
                currency = priceCurrencyCode
        )
    }

    class LaunchBillingFlow(
            private val activity: Activity,
            private val sku: Sku
    ) : ISubscriptionRequests.LaunchBillingFlow(), PurchasesUpdatedListener, AcknowledgePurchaseResponseListener {

        private val billingClient = BillingClient.newBuilder(appContext)
                .enablePendingPurchases()
                .setListener(this)
                .build()

        override fun execute() = billingClient.start(
                onSuccess = { launchBillingFlow() },
                onFailure = { dispatchFailure() }
        )

        override fun onPurchasesUpdated(result: BillingResult?, purchases: MutableList<Purchase>?) {
            when (result?.responseCode) {
                BillingClient.BillingResponseCode.OK -> purchases?.forEach { verify(it) }
                else -> dispatchFailure()
            }
        }

        override fun onAcknowledgePurchaseResponse(result: BillingResult?) {
            when (result?.responseCode) {
                BillingClient.BillingResponseCode.OK -> dispatchSuccess()
                else -> dispatchFailure()
            }
        }

        private fun launchBillingFlow() {
            val params = BillingFlowParams.newBuilder()
                    .setSkuDetails(sku.details as SkuDetails)
                    .build()

            billingClient.launchBillingFlow(activity, params)
        }

        private fun verify(purchase: Purchase) {
            if (purchase.purchaseState == Purchase.PurchaseState.PURCHASED) {
                if (purchase.isAcknowledged) {
                    dispatchSuccess()
                } else {
                    acknowledge(purchase)
                }
            } else {
                dispatchFailure()
            }
        }

        private fun acknowledge(purchase: Purchase) {
            val params = AcknowledgePurchaseParams.newBuilder()
                    .setPurchaseToken(purchase.purchaseToken)
                    .build()

            billingClient.acknowledgePurchase(params, this)
        }

        private fun dispatchSuccess() {
            store.dispatch(Success)
            billingClient.endConnection()
        }

        private fun dispatchFailure() {
            store.dispatch(Failure)
            billingClient.endConnection()
        }
    }

    companion object {
        const val SKU_MONTHLY_SUBSCRIPTION = "monthly_subscription"
    }
}

private fun BillingClient.start(onSuccess: () -> Unit, onFailure: () -> Unit) {
    startConnection(object : BillingClientStateListener {

        override fun onBillingSetupFinished(billingResult: BillingResult) {
            when (billingResult.responseCode) {
                BillingClient.BillingResponseCode.OK -> onSuccess()
                else -> onFailure()
            }
        }

        override fun onBillingServiceDisconnected() {
            onFailure()
        }
    })
}
