//
//  BuddySignInViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 15.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import common
import PKHUD

class BuddySignInViewController: UIViewController, ReKampStoreSubscriber {
    
    private let backButton = UIImageView(image: UIImage(named: "ic_chevron_left")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.ebonyClay
    }
    private let logo = UIImageView().apply {
        $0.image = UIImage(named: "ic_logo")
    }
    private let titleLabel = GiantHeaderLabel().apply {
        $0.text = "welcome".localized
    }
    private let subtitleLabel = SmallHeaderLabel().apply {
        $0.text = "use_your_phone_to_login".localized
        $0.textColor = Palette.slateGray
    }
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
    }
    private let textField = CommonTextField().apply {
        $0.autocapitalizationType = .none
        $0.bind("enter_your_phone_number".localized)
    }
    private let button = CommonButton().apply {
        $0.setTitle("continue".localized.uppercased(), for: .normal)
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
    }
    
    private func buildViewTree() {
        [backButton, logo, titleLabel, subtitleLabel, stackView, button].forEach(view.addSubview)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
    }
    
    private func setConstraints() {
        backButton.run {
            $0.width(32)
            $0.height(32)
            $0.topToSuperview(offset: 12, usingSafeArea: true)
            $0.leadingToSuperview(offset: 12)
        }
        
        logo.run {
            $0.width(72)
            $0.height(72)
            $0.leadingToSuperview(offset: 20)
            $0.topToBottom(of: backButton, offset: 10)
        }
        
        titleLabel.run {
            $0.horizontalToSuperview(insets: .horizontal(20))
            $0.topToBottom(of: logo, offset: 16)
        }
        
        subtitleLabel.run {
            $0.topToBottom(of: titleLabel)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
        
        stackView.run {
            $0.topToBottom(of: subtitleLabel, offset: 36)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
    }
    
    private func setInteractions() {
        backButton.onTap(target: self, action: #selector(backTapped))
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func onButtonTap() {
        let phoneNumber = textField.text ?? ""
        store.dispatch(action: AuthBuddyRequests.GetVerificationCode(phoneNumber: phoneNumber))
    }
    
    func onNewState(state: Any) {
        let state = state as! AuthBuddyState
        
        if case .success = state.signInStatus {
            dismiss(animated: true)
            return
        }
        
        switch(state.getVerificationCodeStatus) {
        case .success:
            hideLoading()
            showVerify()
        case .pending:
            showLoading()
        case .idle:
            hideLoading()
        default:
            break
        }
    }

    private func showVerify() {
        let phoneNumber = textField.text ?? ""
        presentModal(VerifyPhoneViewController(phoneNumber), withNavigation: false, animated: false)
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
