//
//  SubscriptionViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 23.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class SubscriptionViewController: UIViewController, ReKampStoreSubscriber {
    
    private var monthlySku: Sku?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backView = UIImageView(image: UIImage(named: "ic_chevron_left")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.ebonyClay
    }

    private let titleLabel = BigHeaderBoldLabel().apply {
        $0.text = "subscription_title".localized
        $0.textColor = Palette.ebonyClay
    }
    
    private let imageView = UIImageView(image: UIImage(named: "subscription")).apply {
        $0.contentMode = .scaleAspectFit
    }

    private let subscriptionView = SubscriptionOptionView()
    private let button = GradientButton().apply {
        $0.setTitle("continue".localized, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        store.dispatch(action: SubscriptionRequests.FetchSkuDetails())
    }

    private func setupView() {
        view.backgroundColor = Palette.white
        
        buildViewTree()
        setConstraints()
        setInteractions()
    }

    private func buildViewTree() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backView, titleLabel, imageView, subscriptionView, button].forEach(contentView.addSubview)
    }

    private func setConstraints() {
        scrollView.edgesToSuperview()
        contentView.run {
            $0.edgesToSuperview()
            $0.widthToSuperview()
            $0.heightToSuperview(priority: .defaultLow)
        }
        
        backView.run {
            $0.topToSuperview(offset: 12, usingSafeArea: true)
            $0.leadingToSuperview(offset: 22)
            $0.width(32)
            $0.height(32)
        }

        titleLabel.run {
            $0.topToBottom(of: backView, offset: 20)
            $0.horizontalToSuperview(insets: .horizontal(30))
        }

        imageView.run {
            $0.topToBottom(of: titleLabel)
            $0.horizontalToSuperview()
        }

        subscriptionView.run {
            $0.topToBottom(of: imageView, offset: 30)
            $0.width(130)
            $0.height(130)
            $0.centerXToSuperview()
        }
        
        button.run {
            $0.topToBottom(of: subscriptionView, offset: 40)
            $0.centerXToSuperview()
            $0.bottomToSuperview(offset: -10)
        }
    }

    private func setInteractions() {
        backView.run {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backTapped)))
        }
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func backTapped() { finish() }

    @objc func buttonTapped() {
        guard let monthlySku = monthlySku else { return }
        store.dispatch(action: SubscriptionRequests.LaunchBillingFlow(sku: monthlySku))
    }

    private func finish() {
        dismiss(animated: true)
    }

    func onNewState(state: Any) {
        let state = state as! SubscriptionState

        switch state.status {
        case .idle: updateViews(state.monthlySku)
        case .pending: showLoading()
        case .subscribed: finish()
        case .failed: store.dispatch(action: ISubscriptionRequestsReset()); finish()
        default: break
        }
    }

    private func updateViews(_ monthlySku: Sku?) {
        guard let monthlySku = monthlySku else {
            showLoading()
            return
        }

        self.monthlySku = monthlySku

        showContent(monthlySku)
    }

    private func showContent(_ sku: Sku) {
        subscriptionView.run {
            $0.progress.isHidden = true
            $0.content.isHidden = false
            $0.bind(sku.currency, sku.monthlyPriceString)
        }
    }

    private func showLoading() {
        subscriptionView.run {
            $0.progress.isHidden = false
            $0.content.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.subscription.status == newState.subscription.status)
            }.select { state in
                state.subscription
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}
