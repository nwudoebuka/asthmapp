import UIKit
import Firebase
import common
import ContactsUI
import PKHUD

class MoreViewController: UIViewControllerWithCollapsibleTitle, ReKampStoreSubscriber {

    private let tableView = UITableView()
    private let tableAdapter = MoreTableViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }

    private func setupView() {
        view.backgroundColor = Palette.whitesmoke
        buildViewTree()
        setConstraints()
    }

    private func buildViewTree() {
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.edgesToSuperview()
    }

    private func setupTableView() {
        tableView.run {
            $0.backgroundColor = .clear
            $0.dataSource = tableAdapter
            $0.delegate = tableAdapter
            $0.separatorStyle = .none
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.registerForReuse(cellType: BuddiesTableViewCell.self)
            $0.registerForReuse(cellType: EmergencyTableViewCell.self)
            $0.registerForReuse(cellType: MoreTableViewCell.self)
        }
        tableAdapter.run {
            $0.onAddNewTap = {
                self.present(CNContactPickerViewController().apply {
                    $0.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                    $0.delegate = self
                }, animated: true)
            }
            $0.onBuddyTap = { buddy in
                self.presentRemoveBuddyAlert(buddy)
            }
            $0.onProfileTap = {
                self.presentModal(ProfileViewController(), withNavigation: false)
            }
            $0.onEmergencyTap = onEmergencyTap
        }
    }
    
    private func onEmergencyTap() {
        EmergencyStarter().start()
    }

    @objc private func presentRemoveBuddyAlert(_ buddy: Buddy) {
        let alertController = UIAlertController(
            title: "delete_buddy".localized,
            message: "delete_buddy_explanation".localizedFormat(args: buddy.fullName),
            preferredStyle: .alert
        )

        let yesButton = UIAlertAction(title: "yes".localized, style: .cancel) { _ in
            self.removeBuddy(buddy)
        }
        let noButton = UIAlertAction(title: "no".localized, style: .destructive)

        alertController.addAction(yesButton)
        alertController.addAction(noButton)

        present(alertController, animated: true, completion: nil)
    }

    private func removeBuddy(_ buddy: Buddy) {
        store.dispatch(action: HomeRequests.RemoveBuddy(buddy: buddy))
    }

    func onNewState(state: Any) {
        let state = state as! HomeState
        tableAdapter.items = [.emergency, .buddies(state.buddies), .account]
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.home.buddies == newState.home.buddies)
            }.select { state in
                state.home
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}

extension MoreViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard let phoneNumber = (contactProperty.value as? CNPhoneNumber)?.stringValue else { return }
        let contact = contactProperty.contact
        let fullName = "\(contact.givenName) \(contact.familyName)"

        let buddy = ApiAddBuddy(phone: phoneNumber, fullName: fullName, avatar: getContactImageBase64(contact))
        store.dispatch(action: HomeRequests.AddBuddy(buddy: buddy))
    }

    private func getContactImageBase64(_ contact: CNContact) -> String? {
        guard let imageData = contact.imageData else { return nil }
        let image = UIImage(data: imageData)?.getThumbnail()
        return image?.pngData()?.base64EncodedString()
    }
}

fileprivate extension UIImage {

    func getThumbnail() -> UIImage? {
        let imageData = pngData()!
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 100] as CFDictionary
        let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
        return UIImage(cgImage: imageReference)
    }
}
