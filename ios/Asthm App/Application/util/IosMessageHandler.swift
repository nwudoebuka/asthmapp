import UIKit
import common
import Toast_Swift

class IosMessageHandler: MessageHandler {

    func handle(message: String?, messageType: MessageType) {
        if (message != nil) {
            switch(messageType) {
            case .toast:
                UIApplication.shared.keyWindow?.makeToast(message)
            case .alert:
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert
                ).apply {
                    $0.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController?.presentedViewController?.present(alertController, animated: true)
            default:
                break
            }
        }
    }
}
