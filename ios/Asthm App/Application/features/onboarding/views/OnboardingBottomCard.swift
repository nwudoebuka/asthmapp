//
//  OnboardingBottomCard.swift
//  Asthm App
//
//  Created by Den Matiash on 09.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MDCButton
import common

class OnboardingBottomCard: UIView {
    
    private let horizontalLine = UIView().apply {
        $0.backgroundColor = Palette.black.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 3
    }
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let titleLabel = GiantHeaderLabel().apply {
        $0.textColor = Palette.white
    }
    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
    }
    private let stackView2 = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 12
    }
    private let subtitleLabel = BigBodyLabel().apply {
        $0.textColor = Palette.white
    }
    private let addDataView = OnboardingAddDataView()
    private let nextButton = MDCFloatingButton().apply {
        $0.backgroundColor = Palette.white
        $0.setImage(UIImage(named: "ic_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    private let pageControl = UIPageControl().apply {
        $0.currentPageIndicatorTintColor = Palette.white
        $0.pageIndicatorTintColor = Palette.strongBlue
    }
    
    let cornerRadius = 50.0
    private var onButtonTap: (UserUpdateData?) -> () = { _ in }
    private var showAddData = false
    private var onSubtitleTap: () -> () = { }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = Palette.cyanBlue
        layer.masksToBounds = true
        buildViewTree()
        setConstraints()
        setInteractions()
        setupKeyboardBehaviour()
    }
    
    private func buildViewTree() {
        [horizontalLine, scrollView, nextButton, pageControl].forEach(addSubview)
    
        scrollView.addSubview(contentView)
        
        contentView.addSubview(stackView)
        contentView.addSubview(stackView2)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        
        stackView2.addArrangedSubview(subtitleLabel)
        stackView2.addArrangedSubview(addDataView)
    }
    
    private func setConstraints() {
        horizontalLine.run {
            $0.width(60)
            $0.height(6)
            $0.topToSuperview(offset: 20)
            $0.centerXToSuperview()
        }
        scrollView.run {
            $0.topToSuperview(offset: 46)
            $0.horizontalToSuperview(insets: .horizontal(30))
            $0.bottomToTop(of: nextButton, offset: -8)
        }
        contentView.run {
            $0.edgesToSuperview()
            $0.widthToSuperview()
            $0.heightToSuperview(priority: .defaultLow)
        }
        stackView.run {
            $0.topToSuperview()
            $0.horizontalToSuperview()
        }
        stackView2.run {
            $0.topToBottom(of: stackView, offset: 12)
            $0.horizontalToSuperview()
            $0.bottomToSuperview()
        }
        
        nextButton.run {
            $0.bottomToTop(of: pageControl, offset: -6)
            $0.centerXToSuperview()
        }
        
        pageControl.run {
            $0.centerXToSuperview()
            $0.bottomToSuperview()
        }
    }
    
    private func setInteractions() {
        nextButton.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        subtitleLabel.onTap(target: self, action: #selector(onSubtitleClick))
    }
    
    @objc private func onButtonClick() {
        onButtonTap(showAddData ? addDataView.getUserUpdateData() : nil)
    }
    
    @objc private func onSubtitleClick() {
        onSubtitleTap()
    }
    
    struct UIModel {
        let title: String
        let image: UIImage?
        let subtitle: String
        let link: String?
        let numberOfPages: Int
        let currentPage: Int
        let showAddData: Bool
    }
    
    func bind(_ uiModel: UIModel, onSubtitleTap: @escaping () -> (), _ onButtonTap: @escaping (UserUpdateData?) -> ()) {
        titleLabel.text = uiModel.title
        imageView.run {
            $0.image = uiModel.image
            $0.isHidden = uiModel.image == nil
        }
        
        subtitleLabel.attributedText = uiModel.subtitle.attributed.removeTagsAndUnderline()
        
        pageControl.numberOfPages = uiModel.numberOfPages
        pageControl.currentPage = uiModel.currentPage
        
        self.onSubtitleTap = onSubtitleTap
        self.onButtonTap = onButtonTap
        showAddData = uiModel.showAddData
        addDataView.isHidden = !uiModel.showAddData
    }
    
    private func setupKeyboardBehaviour() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardSize - 100
        scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Foundation.Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
}
