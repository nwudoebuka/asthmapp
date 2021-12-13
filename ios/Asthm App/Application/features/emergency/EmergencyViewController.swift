//
//  EmergencyViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 05.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class EmergencyViewController: UIViewController, ReKampStoreSubscriber {

    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let titleLabel = BigHeaderBoldLabel().apply {
        $0.textColor = Palette.white
        $0.text = "alert_mode".localized
    }
    private let exitLabel = BigBodyLabel().apply {
        $0.text = "exit".localized
        $0.textColor = Palette.coralRed
        $0.isHidden = true
    }
    private let buddiesCard = AlertCardViewWithBuddies()
    private let awaitingCallsCard = AlertCardView()
    private let phoneWasNotPickedCard = AlertCardView()
    private let additionalView = UIView()
    private let countdownLabel = UILabel().apply {
        $0.font = UIFont.systemFont(ofSize: 128)
        $0.textColor = Palette.white
    }

    private let callEmergencyButton = UIButton().apply {
        $0.backgroundColor = Palette.indigo
        $0.setTitle("call_emergency".localized.uppercased(), for: .normal)
        $0.layer.cornerRadius = 10
    }

    private let bottomButton = UIButton().apply {
        $0.backgroundColor = Palette.coralRed
        $0.setTitle("stop_alert_mode".localized, for: .normal)
    }

    private weak var timer: Timer?
    private weak var countdownTimer: Timer?

    private var secondsRemained = 10

    // Workaround for checkable TextField in UIAlertViewController
    private var code = ""
    private var cancelAction: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startTimer()
        startCountdown()
    }

    private func setupView() {
        view.backgroundColor = Palette.black

        buildViewTree()
        setConstraints()
        setInteractions()
    }

    private func buildViewTree() {
        [titleLabel, exitLabel, stackView, additionalView, countdownLabel, bottomButton].forEach(view.addSubview)
        [buddiesCard, awaitingCallsCard, phoneWasNotPickedCard, callEmergencyButton].forEach(stackView.addArrangedSubview)
    }

    private func setConstraints() {
        titleLabel.run {
            $0.topToSuperview(offset: 16, usingSafeArea: true)
            $0.leadingToSuperview(offset: 12)
        }
        exitLabel.run {
            $0.centerY(to: titleLabel)
            $0.trailingToSuperview(offset: 16)
        }
        stackView.run {
            $0.topToBottom(of: titleLabel, offset: 16)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        callEmergencyButton.height(52)
        
        additionalView.run {
            $0.topToBottom(of: callEmergencyButton)
            $0.bottomToTop(of: bottomButton)
        }
        countdownLabel.run {
            $0.centerXToSuperview()
            $0.centerY(to: additionalView)
        }

        bottomButton.run {
            $0.height(52)
            $0.edgesToSuperview(excluding: .top)
        }
    }

    private func setInteractions() {
        exitLabel.onTap(target: self, action: #selector(onExitTap))
        callEmergencyButton.addTarget(self, action: #selector(callEmergency), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(onExitTap), for: .touchUpInside)
    }

    @objc private func onExitTap() {
        code = String(Int.random(in: 1000...9999))

        let alertController = UIAlertController(
            title: "cancel_emergency".localized,
            message: "emergency_question".localizedFormat(args: code),
            preferredStyle: .alert
        )

        alertController.addTextField { field in
            field.addTarget(self, action: #selector(self.textChanged(textField:)), for: .editingChanged)
        }

        let backAction = UIAlertAction(title: "back".localized, style: .default, handler: nil)
        alertController.addAction(backAction)

        cancelAction = UIAlertAction(title: "cancel".localized, style: .destructive, handler: { alert -> Void in
            store.dispatch(action: EmergencyRequests.CancelEmergency())
        }).apply { $0.isEnabled = false }
        alertController.addAction(cancelAction!)

        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func callEmergency() {
        guard let url = URL(string: "tel://999") else { return }
        UIApplication.shared.open(url)
    }

    @objc func textChanged(textField: UITextField) {
        cancelAction?.isEnabled = textField.text?.trimmingCharacters(in: .whitespaces) == code
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: Double(Constants().EMERGENCY_TIMER_INTERVAL_IN_MILLIS / 1000),
            repeats: true
        ) { _ in
            store.dispatch(action: EmergencyRequests.GetEmergency())
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func startCountdown() {
        updateCountdown()
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { _ in
            self.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        countdownLabel.text = String(secondsRemained)
        if (secondsRemained < 0) {
            countdownLabel.isHidden = true
            stopCountdown()
        }
    
        secondsRemained -= 1
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
    }

    func onNewState(state: Any) {
        let state = state as! EmergencyState

        guard let emergency = state.emergency else {
            dismiss(animated: true)
            stopTimer()
            stopCountdown()
            return
        }

        bindData(emergency)
    }

    private func bindData(_ emergency: Emergency) {
        buddiesCard.bind(
            .init(
                number: 1,
                text: "sending_sms_to_buddies".localized,
                alertStatus: AlertStatusKt.getAlertStatusFromEmergencyStageNumber(
                    number: 1, status: emergency.status
                ),
                buddies: store.state.home.buddies.filter { $0.status == .accepted }
            )
        )
        awaitingCallsCard.bind(
            .init(
                number: 2,
                text: "awaiting_calls".localized,
                alertStatus: AlertStatusKt.getAlertStatusFromEmergencyStageNumber(
                    number: 2, status: emergency.status
                )
            )
        )
        phoneWasNotPickedCard.bind(
            .init(
                number: 3,
                text: "phone_was_not_picked_up".localized,
                alertStatus: AlertStatusKt.getAlertStatusFromEmergencyStageNumber(
                    number: 3, status: emergency.status
                )
            )
        )

        callEmergencyButton.isHidden = emergency.status != .callingEmergency
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.emergency == newState.emergency)
            }.select { state in
                state.emergency
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}
