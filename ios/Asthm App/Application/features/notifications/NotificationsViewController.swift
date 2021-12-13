import UIKit
import common
import PKHUD

class NotificationsViewController : UIViewControllerWithCollapsibleTitle, ReKampStoreSubscriber {
    
    private let tableView = UITableView()
    private let tableAdapter = NotificationsTableViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        view.backgroundColor = Palette.whitesmoke
        
        navigationItem.rightBarButtonItem = UIBarButtonItemWithText().apply {
            $0.bind("remove_all".localized)
        }
        buildViewTree()
        setConstraints()
        setInteractions()
    }
    
    private func buildViewTree() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.edgesToSuperview()
    }
    
    private func setInteractions() {
        navigationItem.rightBarButtonItem?.customView?.onTap(target: self, action: #selector(onRemoveAllTap))
    }
    
    @objc private func onRemoveAllTap() {
        store.dispatch(action: NotificationsRequests.DeleteAllNotifications())
    }
    
    private func setupTableView() {
        tableView.run {
            $0.backgroundColor = .clear
            $0.delegate = tableAdapter
            $0.dataSource = tableAdapter
            $0.separatorStyle = .none
            $0.registerForReuse(cellType: NotificationTableViewCell.self)
            $0.registerForReuse(cellType: EmergencyTableViewCell.self)
        }
        tableAdapter.run {
            $0.shouldOpenLink = { link in
                self.presentModal(WebViewController(link))
            }
            $0.shouldOpenAddData = {
                AddDataStarter().start(self)
            }
            $0.onEmergencyTap = onEmergencyTap
        }
    }
    
    private func onEmergencyTap() {
        EmergencyStarter().start()
    }
    
    func onNewState(state: Any) {
        let state = state as! NotificationsState
        
        tableAdapter.items = [NotificationItem.emergency] + state.notifications.map {
            NotificationItem.notification(NotificationItem.Notification(notification: $0))
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.notifications == newState.notifications)
            }.select { state in
                state.notifications
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}
