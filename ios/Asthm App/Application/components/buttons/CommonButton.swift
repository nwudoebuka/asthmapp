import UIKit

class CommonButton: UIButton {
    
    private let arrowLabel = UIImageView(image: UIImage(named: "ic_chevron_right")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        titleLabel?.font = Font.smallHeader
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 36, bottom: 10, right: 36)
        backgroundColor = Palette.royalBlue
        
        layer.run {
            $0.cornerRadius = 4
            $0.masksToBounds = true
        }
        
        addSubview(arrowLabel)
        arrowLabel.run {
            $0.width(28)
            $0.height(28)
            $0.centerYToSuperview()
            $0.trailingToSuperview(offset: 10)
        }
        height(54)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
