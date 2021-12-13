import UIKit

class HintLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        font = Font.hint
        textColor = Palette.slateGray
        numberOfLines = 0
    }
}
