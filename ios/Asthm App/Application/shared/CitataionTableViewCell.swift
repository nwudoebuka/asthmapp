
import Foundation
import UIKit

class CitataionTableViewCell: UITableViewCell {
    
    private let label = HintLabel()
    private let cardView = CardViewWithRightArrow()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        buildViewTree()
        setConstraints()
        setData()
    }
    
    private func buildViewTree() {
        addSubview(cardView)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16))
    }
    
    private func setData() {
        cardView.bind(
            CardViewWithRightArrow.UIModel(
                text: "All medical resources are gotten from here".localized,
                imageView: nil,
                color: Palette.royalBlue,
                font: Font.bigBody,
                isActionable: true
            )
        )
    }
}
