import Foundation
import UIKit
import MaterialComponents.MDCButton
import common

class MainViewController: UITabBarController, ReKampStoreSubscriber {
    
    private let fabButton = MDCFloatingButton().apply {
        $0.backgroundColor = Palette.white
        $0.tintColor = Palette.slateGray
        $0.setImage(UIImage(named: "ic_plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    private let controllers = [
        HomeViewController().apply(title: "home", iconNamed: "ic_home"),
        LearnViewController().apply(title: "learn", iconNamed: "ic_learn"),
        UIViewController(),
        NotificationsViewController().apply(title: "notifications", iconNamed: "ic_notifications"),
        MoreViewController().apply(title: "more", iconNamed: "ic_more")
    ]

    required init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        if let tabBarArray = tabBar.items {
            tabBarArray[2].isEnabled = false
        }
        
        addFabButton()
        updateFabButton()
        fetchData()
    }
    
    private func addFabButton() {
        tabBar.addSubview(fabButton)
        
        fabButton.run {
            $0.topToSuperview(offset: -22)
            $0.centerXToSuperview()
        }
        fabButton.addTarget(self, action: #selector(fabButtonTapped), for: .touchUpInside)
    }
    
    @objc private func fabButtonTapped() {
        AddDataStarter().start(self)
    }
    
    private func fetchData() {
        store.dispatch(action: NotificationsRequests.FetchNotifications())
        store.dispatch(action: LearnRequests.FetchNews())
        store.dispatch(action: HomeRequests.FetchHome())
        store.dispatch(action: EmergencyRequests.GetEmergency())
    }
    
    func onNewState(state: Any) {
        let state = state as! AppState
        if state.emergency.emergency != nil {
            self.presentModal(EmergencyViewController(), withNavigation: false)
        }
        switch(state.subscription.status) {
        case .failed:
            updateFabButton()
        case .subscribed:
            updateFabButton()
        default:
            break
        }
    }
    
    private func updateFabButton() {
        if SettingsKt.settings.getIsSubscribed() {
            fabButton.setImage(UIImage(named: "ic_plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            fabButton.setImage(UIImage(named: "ic_lock")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboardingIfNeeded()
    }
    
    private func showOnboardingIfNeeded() {
        if !SettingsKt.settings.getIsOnboardingShown() {
            presentModal(OnboardingViewController(), withNavigation: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                return KotlinBoolean(bool: oldState.emergency == newState.emergency && oldState.subscription == newState.subscription
                )
            }.select { state in
                return state
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}

fileprivate extension UIViewController {

    func apply(title: String, iconNamed: String, isTitleVisible: Bool = true) -> UIViewController {
        let tabBarItem = UITabBarItem(title: title.localized, image: UIImage(named: iconNamed), selectedImage: nil)

        if isTitleVisible { self.title = title.localized }
        self.tabBarItem = tabBarItem

        return self
    }
}
