import Foundation
import UIKit

private let GRADIENT_LAYER = "gradient_layer"

enum GradientType {
    case vertical, horizontal
}

extension UIView {

    func onTap(target: Any, action: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    func addLinearGradient(_ firstColor: UIColor, _ secondColor: UIColor, _ gradientType: GradientType) {
        let gradientLayer = CAGradientLayer().apply {
            $0.frame = bounds
            $0.colors = [firstColor.cgColor, secondColor.cgColor]
            $0.startPoint = CGPoint(x: 0, y: 0)
            $0.endPoint = gradientType == .horizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 1)
            $0.name = GRADIENT_LAYER
        }
        
        layer.sublayers?.forEach {
            if ($0.name == GRADIENT_LAYER) {
                $0.removeFromSuperlayer()
            }
        }
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: Double) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer().apply {
            $0.path = path.cgPath
        }
        
        self.layer.run {
            $0.cornerRadius = 0
            $0.mask = mask
        }
    }
}
