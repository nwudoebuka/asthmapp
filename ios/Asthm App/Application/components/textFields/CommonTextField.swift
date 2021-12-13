import UIKit

class CommonTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        font = Font.smallHeader
        borderStyle = .none
        tintColor = Palette.royalBlue
        autocorrectionType = .no
        spellCheckingType = .no
        textAlignment = .center

        layer.run {
            $0.backgroundColor = Palette.white.cgColor
            $0.borderWidth = 1
            $0.borderColor = Palette.ebonyClay.withAlphaComponent(0.5).cgColor
            $0.cornerRadius = 5
        }
        height(54)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ placeholder: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: Palette.slateGray])
        
    }
}
