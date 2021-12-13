import Foundation
import UIKit

extension String {

    var localized: String {
        let string = NSLocalizedString(self, comment: "")

        if
            string == self, //the translation was not found
            let baseLanguagePath = Bundle.main.path(forResource: "Base", ofType: "lproj"),
            let baseLangBundle = Bundle(path: baseLanguagePath) {

            return NSLocalizedString(self, bundle: baseLangBundle, comment: "")
        } else {
            return string
        }
    }
    
    func localizedFormat(args: CVarArg...) -> String {
        let format = self.localized
        return String(format: format, arguments: args)
    }
    
    var attributed: NSMutableAttributedString { return NSMutableAttributedString(string: self) }
    
    var underlined: NSAttributedString {
        return self.attributed.apply {
            $0.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: self.count))
        }
    }
    
    func colorString(color: UIColor) -> NSAttributedString {
        return self.attributed.apply {
            $0.addAttribute(
                .foregroundColor,
                value: color,
                range: NSRange(location: 0, length: self.count)
            )
        }
    }
    
    var crossed: NSAttributedString {
        return self.attributed.apply {
            $0.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSMakeRange(0, self.count)
            )
        }
    }
}
