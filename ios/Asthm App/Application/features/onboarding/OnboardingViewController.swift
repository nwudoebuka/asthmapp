//
//  OnboardingViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 08.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import PKHUD

class OnboardingViewController: UIViewController, ReKampStoreSubscriber {
    
    private let skipLabel = SmallHeaderLabel().apply {
        $0.text = "skip".localized
        $0.isHidden = true
    }
    private let containerView = UIView()
    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
    }
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 12
    }
    private let titleLabel = BigHeaderBoldLabel().apply {
        $0.textAlignment = .center
    }
    private let subtitleLabel = SmallHeaderLabel().apply {
        $0.textAlignment = .center
    }
    private let continueButton = GradientButton().apply {
        $0.setTitle("continue".localized.uppercased(), for: .normal)
    }
    private let checkmarkButton = UIButton().apply {
        $0.isHidden = true
        $0.setImage(UIImage(named: "ic_checkmark"), for: .normal)
        $0.contentEdgeInsets = .uniform(30)
        $0.layer.run {
            $0.masksToBounds = true
        }
    }
    
    private let blackView = UIView().apply {
        $0.isHidden = true
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    private let bottomCard = OnboardingBottomCard().apply {
        $0.isHidden = true
    }
    
    private var currentItemIndex = -1
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomCard.roundCorners(corners: [.topLeft, .topRight], radius: bottomCard.cornerRadius)
        checkmarkButton.run {
            $0.addLinearGradient(Palette.cyanBlue, Palette.cyan, .horizontal)
            $0.layer.cornerRadius = checkmarkButton.frame.width / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        moveToNext()
    }
    
    private func setupView() {
        view.backgroundColor = Palette.white
        
        buildViewTree()
        setConstraints()
        setInteractions()
    }
    
    private func buildViewTree() {
        [containerView, blackView, skipLabel, bottomCard].forEach(view.addSubview)
        [imageView, stackView, continueButton, checkmarkButton].forEach(containerView.addSubview)
        [titleLabel, subtitleLabel].forEach(stackView.addArrangedSubview)
    }
    
    private func setConstraints() {
        skipLabel.run {
            $0.topToSuperview(offset: 40)
            $0.trailingToSuperview(offset: 42)
        }
        containerView.run {
            $0.centerYToSuperview()
            $0.horizontalToSuperview()
        }
        imageView.run {
            $0.topToSuperview()
            $0.horizontalToSuperview()
        }
        stackView.run {
            $0.topToBottom(of: imageView, offset: 36)
            $0.horizontalToSuperview(insets: .horizontal(62))
        }
        continueButton.run {
            $0.topToBottom(of: stackView, offset: 34)
            $0.centerXToSuperview()
            $0.bottomToSuperview()
        }
        checkmarkButton.run {
            $0.topToBottom(of: stackView, offset: 20)
            $0.centerXToSuperview()
            $0.bottomToSuperview(offset: 26, relation: .equalOrLess)
        }
        blackView.edgesToSuperview()
        bottomCard.run {
            $0.edgesToSuperview(excluding: .top)
            $0.topToBottom(of: imageView, offset: 8)
        }
    }
    
    private func setInteractions() {
        skipLabel.onTap(target: self, action: #selector(onSkipTap))
        continueButton.addTarget(self, action: #selector(onContinueTap), for: .touchUpInside)
        checkmarkButton.addTarget(self, action: #selector(onContinueTap), for: .touchUpInside)
    }
    
    @objc private func onSkipTap() {
        dismiss(animated: true)
    }
    
    @objc private func onContinueTap() {
        moveToNext()
    }
    
    func onNewState(state: Any) {
        let state = state as! OnboardingState
        switch(state.submitDataStatus) {
        case .success:
            SettingsKt.settings.putIsOnboardingShown()
            skipLabel.isHidden = false
            hideLoading()
            moveToNext()
            store.dispatch(action: OnboardingRequests.Destroy())
        case .pending:
            showLoading()
        case .idle:
            hideLoading()
        default:
            break
        }
    }
    
    private func moveToNext() {
        currentItemIndex += 1
        if (currentItemIndex == items.count) {
            dismiss(animated: true)
            return
        }
        switch(items[currentItemIndex]) {
        case .start(let item):
            imageView.image = item.backgroundImage
            titleLabel.text = item.title
            subtitleLabel.text = item.subtitle
        case .info(let item):
            imageView.image = item.backgroundImage
            blackView.isHidden = false
            bottomCard.isHidden = false
            bottomCard.bind(item.uiModel, onSubtitleTap: {
                self.openLink(item.uiModel.link)
            }) { _ in
                self.moveToNext()
            }
        case .finish(let item):
            imageView.image = item.backgroundImage
            titleLabel.text = item.title
            subtitleLabel.isHidden = true
            blackView.isHidden = true
            bottomCard.isHidden = true
            continueButton.isHidden = true
            checkmarkButton.isHidden = false
        case .addData(let item):
            imageView.image = item.backgroundImage
            blackView.isHidden = false
            bottomCard.isHidden = false
            bottomCard.bind(item.uiModel, onSubtitleTap: {
                self.openLink(item.uiModel.link)
            }) { data in
                guard let data = data else { return }
                store.dispatch(action: OnboardingRequests.UpdateData(data: data))
            }
        }
    }
    
    private func openLink(_ link: String?) {
        guard let link = link else { return }
        presentModal(WebViewController(link))
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
                KotlinBoolean(bool: oldState.onboarding == newState.onboarding)
            }.select { state in
                state.onboarding
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
    
    private let items: [OnboardingItem] = [
        .start(
            .init(
                backgroundImage: UIImage(named: "onboarding_0"),
                title: "onboarding_0_title".localized,
                subtitle: "onboarding_0_text".localized
            )
        ),
        .addData(
            .init(
                backgroundImage: UIImage(named: "onboarding_1"),
                uiModel: .init(
                    title: "onboarding_1_title".localized,
                    image: nil,
                    subtitle: "onboarding_1_text".localized,
                    link: nil,
                    numberOfPages: 7,
                    currentPage: 0,
                    showAddData: true
                )
            )
        ),
        .info(
            .init(
                backgroundImage: UIImage(named: "onboarding_2"),
                uiModel: .init(
                    title: "onboarding_2_title".localized,
                    image: nil,
                    subtitle: "onboarding_2_text".localized,
                    link: nil,
                    numberOfPages: 7,
                    currentPage: 1,
                    showAddData: false
                )
            )
        ),
        .info(
            .init(
                backgroundImage: UIImage(named: "onboarding_3"),
                uiModel: .init(
                    title: "onboarding_3_title".localized,
                    image: nil,
                    subtitle: "onboarding_3_text".localized,
                    link: nil,
                    numberOfPages: 7,
                    currentPage: 2,
                    showAddData: false
                )
            )
        ),
        .info(
            .init(
                backgroundImage: UIImage(named: "onboarding_4"),
                uiModel: .init(
                    title: "onboarding_4_title".localized,
                    image: nil,
                    subtitle: "onboarding_4_text".localized,
                    link: nil,
                    numberOfPages: 7,
                    currentPage: 3,
                    showAddData: false
                )
            )
        ),
        .info(
            .init(
                backgroundImage: UIImage(named: "onboarding_5"),
                uiModel: .init(
                    title: "onboarding_5_title".localized,
                    image: nil,
                    subtitle: "onboarding_5_text".localized,
                    link: nil,
                    numberOfPages: 7,
                    currentPage: 4,
                    showAddData: false
                )
            )
        ),
        .info(
            .init(
                backgroundImage: UIImage(named: "onboarding_6"),
                uiModel: .init(
                    title: "onboarding_6_title".localized,
                    image: nil,
                    subtitle: "onboarding_6_text".localized,
                    link: nil,
                    numberOfPages: 7,
                    currentPage: 5,
                    showAddData: false
                )
            )
        ),
        .info(
            .init(
                backgroundImage: UIImage(named: "onboarding_7"),
                uiModel: .init(
                    title: "onboarding_7_title".localized,
                    image: UIImage(named: "oximeter"),
                    subtitle: "onboarding_7_text".localized,
                    link: Constants().WEBSITE_LINK,
                    numberOfPages: 7,
                    currentPage: 6,
                    showAddData: false
                )
            )
        ),
        .finish(
            .init(
                backgroundImage: UIImage(named: "onboarding_7"),
                title: "onboarding_8_title".localized
            )
        )
    ]
}
