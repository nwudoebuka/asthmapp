//
//  SplashViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 06.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    private let animationView = AnimationView(name: "splashscreen")
    private let logo = UIImageView().apply {
        $0.image = UIImage(named: "ic_logo")
    }
    private let titleLabel = GiantHeaderLabel().apply {
        $0.text = "welcome".localized
    }
    private let noteLabel = SmallHeaderBoldLabel().apply {
        $0.text = "Note:"
    }
    private let subtitleLabel = SmallHeaderLabel().apply {
        $0.text = "choose_your_role".localized
        $0.textColor = Palette.slateGray
    }
    private let jurisdictionLabel = SmallHeaderLabel().apply {
        $0.text = "jurisdicial_statement".localized
        $0.textColor = Palette.slateGray
    }
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
    }
    private let asthmaSuffererButton = CommonButton().apply {
        $0.setTitle("main_user".localized.uppercased(), for: .normal)
    }
    private let buddyButton = CommonButton().apply {
        $0.setTitle("buddy".localized.uppercased(), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideAllViews()
    }
    
    private func setupView() {
        view.backgroundColor = Palette.white
        buildViewTree()
        setConstraints()
        setInteractions()
    }
    
    private func buildViewTree() {
        [animationView, logo, titleLabel, subtitleLabel, stackView,noteLabel,jurisdictionLabel].forEach(view.addSubview)
        
        stackView.addArrangedSubview(asthmaSuffererButton)
        stackView.addArrangedSubview(buddyButton)
    }
    
    private func setConstraints() {
        animationView.edgesToSuperview()
        
        logo.run {
            $0.width(72)
            $0.height(72)
            $0.leadingToSuperview(offset: 20)
            $0.topToSuperview(offset: 40)
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
        noteLabel.run {
            $0.topToBottom(of: stackView,offset: 40)
            $0.horizontalToSuperview(insets: .horizontal(20))
            
        }
        jurisdictionLabel.run {
            $0.topToBottom(of: noteLabel,offset: 8)
            $0.horizontalToSuperview(insets: .horizontal(20))
        }
     
    }
    
    private func setInteractions() {
        asthmaSuffererButton.addTarget(self, action: #selector(onAsthmaSuffererTap), for: .touchUpInside)
        buddyButton.addTarget(self, action: #selector(onBuddyTap), for: .touchUpInside)
    }
    
    @objc private func onAsthmaSuffererTap() {
        presentModal(SignInViewController(), withNavigation: false)
        hideAllViews()
    }
    
    @objc private func onBuddyTap() {
        presentModal(BuddySignInViewController(), withNavigation: false)
        hideAllViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hideAllViews()
        animationView.isHidden = false
        
        animationView.play(completion: { _ in
            self.showNextViewController()
        })
    }
    
    private func showNextViewController() {
        if store.state.auth.user != nil {
            self.presentModal(MainViewController(), withNavigation: false, animated: false)
        } else if store.state.authBuddy.user != nil {
            self.presentModal(BuddyMainViewController(), withNavigation: true, animated: false)
        } else {
            showAllViews()
            animationView.isHidden = true
        }
    }
    
    private func hideAllViews() {
        view.subviews.forEach { $0.isHidden = true }
    }
    
    private func showAllViews() {
        view.subviews.forEach { $0.isHidden = false }
    }
}
