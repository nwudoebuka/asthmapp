import Foundation
import UIKit

class TextTableViewCell: UITableViewCell {
    
    private let label = BodyLabel()
    private let cardView = CardViewWithRightArrow()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        label.apply {
            $0.text = "Welcome to AshtmaApp"
            $0.textColor = UIColor.black
            $0.numberOfLines = 0
        }
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
        //addSubview(cardView)
        addSubview(cardView)
    }
    
    private func setConstraints() {
        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 50, left: 16, bottom: 4, right: 16))
     
//        label.apply{
//        $0.topToSuperview()
//        $0.bottomToSuperview()
//        $0.trailingToSuperview()
//        $0.leadingToSuperview()
//        }
    }
    
    private func setData() {
        cardView.apply {
            $0.backgroundColor = UIColor.clear
            
        }
        cardView.bind(
            CardViewWithRightArrow.UIModel(
                text: "Welcome to AshtmaApp, we have amazing features to help you with Ashma Incidents, you can also contact us is you need personal assistance.".localized,
                imageView: nil,
                color: UIColor.black,
                font: Font.bigBody,
                isActionable: false
            )
        )
    }
}


//import Foundation
//import UIKit
//
//class TextTableViewCell: UITableViewCell {
//
//    private let label = HintLabel()
//    private let cardView = CardViewWithRightArrow()
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
//
//    private func setupView() {
//        selectionStyle = .none
//        backgroundColor = .clear
//
//        buildViewTree()
//        setConstraints()
//        setData()
//    }
//
//    private func buildViewTree() {
//        addSubview(cardView)
//    }
//
//    private func setConstraints() {
//        cardView.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16))
//    }
//
//    private func setData() {
//        cardView.bind(
//            CardViewWithRightArrow.UIModel(
//                text: "All medical resources are gotten from here".localized,
//                imageView: nil,
//                color: Palette.royalBlue,
//                font: Font.bigBody,
//                isActionable: true
//            )
//        )
//    }
//}
