//
//  ProfileViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 03.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import PKHUD

class ProfileViewController: UIViewController, ReKampStoreSubscriber {

    private let backButton = UIImageView(image: UIImage(named: "ic_chevron_left")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.white
    }
    private let gradientView = UIView()
    private let profileImage = CircleImageView().apply {
        $0.layer.run {
            $0.borderWidth = 2.5
            $0.borderColor = Palette.white.cgColor
            $0.masksToBounds = true
        }
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "ic_profile")
    }
    private let editImage = CircleImageView().apply {
        $0.image = UIImage(named: "ic_edit")
        $0.isHidden = true
    }
    private let nameLabel = BigHeaderLabel().apply {
        $0.textAlignment = .center
    }
    private let emailCard = ProfileCardView()
    private let horizontalLine = UIView().apply {
        $0.backgroundColor = Palette.ebonyClay.withAlphaComponent(0.5)
    }
    private let subscriptionsCard = ProfileCardView().apply {
        $0.bind(.init(
            leftImage: UIImage(named: "ic_gift"),
            text: "my_subscriptions".localized,
            rightImage: UIImage(named: "ic_chevron_right"),
            font: Font.smallHeader,
            textColor: Palette.ebonyClay
        ))
    }
    private let privacyPolicyCard = ProfileCardView().apply {
        $0.bind(.init(
            leftImage: UIImage(named: "ic_lock"),
            text: "privacy_policy".localized,
            rightImage: UIImage(named: "ic_chevron_right"),
            font: Font.smallHeader,
            textColor: Palette.ebonyClay
        ))
    }
    private let termsAndConditionsCard = ProfileCardView().apply {
        $0.bind(.init(
            leftImage: UIImage(named: "ic_document"),
            text: "terms_and_conditions".localized,
            rightImage: UIImage(named: "ic_chevron_right"),
            font: Font.smallHeader,
            textColor: Palette.ebonyClay
        ))
    }
    private let logoutCard = ProfileCardView().apply {
        $0.bind(.init(
            leftImage: nil,
            text: "log_out".localized,
            rightImage: UIImage(named: "ic_chevron_right"),
            font: Font.smallHeader,
            textColor: Palette.coralRed
        ))
    }
    private let deleteAccountCard = ProfileCardView().apply {
        $0.bind(.init(
            leftImage: UIImage(named: "ic_delete"),
            text: "delete_account".localized,
            rightImage: nil,
            font: Font.smallHeader,
            textColor: Palette.coralRed
        ))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = Palette.whitesmoke
        buildViewTree()
        setConstraints()
        setInteractions()
        bindData()
    }

    private func buildViewTree() {
        [gradientView, backButton, profileImage, editImage, nameLabel, emailCard, horizontalLine, subscriptionsCard,
         privacyPolicyCard, termsAndConditionsCard, logoutCard, deleteAccountCard].forEach(view.addSubview)
    }

    private func setConstraints() {
        backButton.run {
            $0.width(32)
            $0.height(32)
            $0.topToSuperview(offset: 12, usingSafeArea: true)
            $0.leadingToSuperview(offset: 12)
        }
        gradientView.run {
            $0.topToSuperview()
            $0.horizontalToSuperview()
            $0.height(148)
        }
        profileImage.run {
            $0.topToSuperview(offset: 74)
            $0.centerXToSuperview()
            $0.width(120)
            $0.height(120)
        }
        editImage.run {
            $0.width(32)
            $0.height(32)
            $0.top(to: profileImage, offset: -8)
            $0.trailing(to: profileImage, offset: -4)
        }
        nameLabel.run {
            $0.topToBottom(of: profileImage, offset: 8)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        emailCard.run {
            $0.topToBottom(of: nameLabel, offset: 22)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        horizontalLine.run {
            $0.topToBottom(of: emailCard, offset: 28)
            $0.horizontalToSuperview()
            $0.height(0.25)
        }
        subscriptionsCard.run {
            $0.topToBottom(of: horizontalLine, offset: 28)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        privacyPolicyCard.run {
            $0.topToBottom(of: subscriptionsCard, offset: 14)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        termsAndConditionsCard.run {
            $0.topToBottom(of: privacyPolicyCard, offset: 14)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        logoutCard.run {
            $0.topToBottom(of: termsAndConditionsCard, offset: 14)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
        deleteAccountCard.run {
            $0.isHidden = true
            $0.bottomToSuperview(offset: -22)
            $0.horizontalToSuperview(insets: .horizontal(12))
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.addLinearGradient(Palette.moderateBlue, Palette.strongMagenta, .horizontal)
    }

    private func setInteractions() {
        backButton.onTap(target: self, action: #selector(backTapped))
        emailCard.onTap(target: self, action: #selector(onEmailTap))
        subscriptionsCard.onTap(target: self, action: #selector(onSubscriptionsTap))
        privacyPolicyCard.onTap(target: self, action: #selector(onPrivacyPolicyTap))
        termsAndConditionsCard.onTap(target: self, action: #selector(onTermsAndConditionsTap))
        logoutCard.onTap(target: self, action: #selector(onLogOutTap))
    }
    
    @objc private func onSubscriptionsTap() {
        let link = "itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/DirectAction/manageSubscriptions"
        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
    }

    @objc private func onEmailTap() {
        guard let user = store.state.auth.user else { return }
        if !user.isEmailVerified {
            store.dispatch(action: AuthRequests.VerifyEmail())
        }
    }

    @objc private func onPrivacyPolicyTap() {
        presentModal(WebViewController(Constants().PRIVACY_POLICY_LINK))
    }

    @objc private func onTermsAndConditionsTap() {
        presentModal(WebViewController(Constants().TERMS_AND_CONDITIONS_LINK))
    }

    @objc private func onLogOutTap() {
        let alertController = UIAlertController(
            title: "log_out".localized,
            message: "do_you_want_to_log_out".localized,
            preferredStyle: .alert
        )

        let stayLoggedInButton = UIAlertAction(
            title: "stay_logged_in".localized,
            style: .default
        )
        let logOutButton = UIAlertAction(
            title: "log_out".localized,
            style: .destructive,
            handler: { _ in self.logOut() })
        
        [stayLoggedInButton, logOutButton].forEach(alertController.addAction)

        present(alertController, animated: true, completion: nil)
    }

    private func logOut() {
        try? Firebase.auth.signOut()
        store.dispatch(action: IAuthRequestsLogOut())

        dismiss(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewController.dismiss(animated: true)
    }

    @objc private func backTapped() {
        dismiss(animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.dispatch(action: IAuthRequestsDestroyVerifyEmail())
    }

    private func bindData() {
        guard let user = store.state.auth.user else { return }
        nameLabel.text = user.name
        emailCard.bind(.init(
            leftImage: UIImage(named: "ic_email"),
            text: user.email,
            rightImage: user.isEmailVerified ? nil : UIImage(named: "ic_unverified"),
            font: user.isEmailVerified ? Font.smallHeader : Font.smallHeaderBold,
            textColor: Palette.ebonyClay
        ))

        guard let photoUrl = user.photoUrl else { return }
        profileImage.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(named: "ic_profile"))
    }

    func onNewState(state: Any) {
        let state = state as! AuthState
        switch (state.verifyStatus) {
        case .success:
            hideLoading()
            showVerifyEmailAlert()
        case .pending:
            showLoading()
        case .idle:
            hideLoading()
        default:
            break
        }
    }

    private func showVerifyEmailAlert() {
        let alertController = UIAlertController(
            title: "verify_email".localized,
            message: "please_check_your_email_inbox".localized,
            preferredStyle: .alert
        ).apply {
            $0.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
        }

        present(alertController, animated: true)
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
                KotlinBoolean(bool: oldState.auth.verifyStatus == newState.auth.verifyStatus)
            }.select { state in
                state.auth
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}
