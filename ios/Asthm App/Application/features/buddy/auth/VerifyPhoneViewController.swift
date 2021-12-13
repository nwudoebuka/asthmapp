//
//  VerifyPhoneViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 16.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import PKHUD

class VerifyPhoneViewController: UIViewController, ReKampStoreSubscriber {
    
    private let titleLabel = SmallHeaderBoldLabel().apply {
        $0.textAlignment = .center
        $0.text = "verify_phone".localized.uppercased()
    }
    private let subtitleLabel = BigBodyLabel().apply {
        $0.textAlignment = .center
    }
    private let timerLabel = BigHeaderLabel().apply {
        $0.textAlignment = .center
        $0.textColor = Palette.royalBlue
    }
    private let textField = CommonTextField().apply {
        $0.placeholder = "enter_verification_code".localized
    }
    
    private let button = CommonButton().apply {
        $0.setTitle("verify".localized.uppercased(), for: .normal)
    }
    
    private let bottomLabel = BigBodyLabel().apply {
        $0.textAlignment = .center
        $0.text = "did_not_recieve_a_code".localized
    }
    private let resendLabel = BigBodyBoldLabel().apply {
        $0.attributedText = "resend".localized.underlined
        $0.textAlignment = .center
    }
    
    private let phoneNumber: String
    private weak var timer: Timer?
    private var secondsToResend = 0
    
    init(_ phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Palette.white
        buildViewTree()
        setConstraints()
        setInteractions()
        
        bindData()
        startTimer()
    }
    
    private func buildViewTree() {
        [titleLabel, subtitleLabel, timerLabel, textField, button, bottomLabel, resendLabel].forEach(view.addSubview)
    }
    
    private func setConstraints() {
        titleLabel.run {
            $0.topToSuperview(offset: 50, usingSafeArea: true)
            $0.horizontalToSuperview()
        }
        subtitleLabel.run {
            $0.topToBottom(of: titleLabel, offset: 8)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
        timerLabel.run {
            $0.topToBottom(of: subtitleLabel, offset: 16)
            $0.horizontalToSuperview()
        }
        textField.run {
            $0.topToBottom(of: timerLabel, offset: 20)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
        button.run {
            $0.topToBottom(of: textField, offset: 16)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
        bottomLabel.run {
            $0.topToBottom(of: button, offset: 64)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
        resendLabel.run {
            $0.topToBottom(of: bottomLabel)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
    }
    
    private func setInteractions() {
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        resendLabel.onTap(target: self, action: #selector(onResendTap))
    }
    
    private func bindData() {
        subtitleLabel.text = "verify_phone_explanation".localizedFormat(args: String(phoneNumber.suffix(2)))
    }
    
    @objc private func onButtonTap() {
        let verifyCode = textField.text ?? ""
        store.dispatch(action: AuthBuddyRequests.VerifyCode(code: verifyCode))
    }
    
    @objc private func onResendTap() {
        if secondsToResend == 0 {
            store.dispatch(action: AuthBuddyRequests.GetVerificationCode(phoneNumber: phoneNumber))
            startTimer()
        }
    }
    
    private func startTimer() {
        secondsToResend = 60 * 5
        updateUI()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsToResend -= 1
            if self.secondsToResend == 0 {
                self.stopTimer()
            }
            self.updateUI()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func updateUI() {
        let minutes = secondsToResend / 60
        let seconds = secondsToResend % 60
        timerLabel.text = String(format: "%02i:%02i", minutes, seconds)
        
        resendLabel.textColor = secondsToResend == 0 ? Palette.royalBlue : Palette.slateGray
    }
    
    func onNewState(state: Any) {
        let state = state as! AuthBuddyState
        switch(state.signInStatus) {
        case .success:
            hideLoading()
            stopTimer()
            dismiss(animated: false)
        case .pending:
            showLoading()
        case .idle:
            hideLoading()
        default:
            break
        }
    }
    
    private func showLoading() {
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        HUD.show(.progress, onView: navigationController?.view)
    }

    private func hideLoading() {
        HUD.hide(afterDelay: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.authBuddy == newState.authBuddy)
            }.select { state in
                state.authBuddy
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}
