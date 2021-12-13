import UIKit

class SocialLoginButton: UIView {

    private let leftView = UIView()
    private let dividerView = UIView()
    private let rightView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = SmallHeaderLabel()
    private let uiModel: UIModel
    
    struct UIModel {
        let title: String
        let image: UIImage?
        let textColor: UIColor
        let dividerColor: UIColor
        let backgroundColor: UIColor
    }
    
    init(_ uiModel: UIModel) {
        self.uiModel = uiModel
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.run {
            $0.cornerRadius = 4
            $0.masksToBounds = true
            $0.borderWidth = 1
            $0.borderColor = Palette.ebonyClay.withAlphaComponent(0.5).cgColor
            $0.cornerRadius = 5
        }

        buildViewTree()
        setConstraints()
        bindData()
    }

    private func buildViewTree() {
        addSubview(leftView)
        addSubview(dividerView)
        addSubview(rightView)
        leftView.addSubview(imageView)
        rightView.addSubview(titleLabel)
    }

    private func setConstraints() {
        leftView.run {
            $0.edgesToSuperview(excluding: .trailing)
            $0.width(70)
        }
        imageView.centerInSuperview()
        dividerView.run {
            $0.verticalToSuperview()
            $0.leadingToTrailing(of: leftView)
            $0.width(1)
        }
        rightView.run {
            $0.leadingToTrailing(of: dividerView)
            $0.edgesToSuperview(excluding: .leading)
        }
        titleLabel.centerInSuperview()
    }
    
    private func bindData() {
        titleLabel.run {
            $0.text = uiModel.title
            $0.textColor = uiModel.textColor
        }
        backgroundColor = uiModel.backgroundColor
        imageView.image = uiModel.image
        dividerView.backgroundColor = uiModel.dividerColor
    }
}
