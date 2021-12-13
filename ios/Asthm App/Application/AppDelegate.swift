import UIKit
import common
import Firebase
import GoogleSignIn
import FacebookCore
import FirebaseMessaging
import GoogleMaps

let store = AppStoreKt.store

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootViewController = SplashViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initMessageHandler()

        configureFirebase()
        configureGoogleSignIn()
        configureFacebookSignIn(application, launchOptions)
        registerForPushNotifications(application)

        initFetchSubscriptionsRequestProvider()
        initAppStyle()
        fetchUser()
        initPrefs()
        initGoogleMaps()

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    private func initMessageHandler() {
        MessageMiddlewareKt.messageHandlers.add(IosMessageHandler())
    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }

    private func configureGoogleSignIn() {
        GIDSignIn.sharedInstance().run {
            $0.clientID = FirebaseApp.app()?.options.clientID
            $0.delegate = self
        }
    }

    private func configureFacebookSignIn(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    private func initFetchSubscriptionsRequestProvider() {
        AppMiddlewareKt.fetchSubscriptionsRequestProvider = { SubscriptionRequests.FetchSubscriptions() }
    }

    private func initAppStyle() {
        UINavigationBar.appearance().run {
            $0.isTranslucent = false
            $0.barTintColor = Palette.whitesmoke
            $0.tintColor = Palette.whitesmoke
        }

        UITabBar.appearance().run {
            $0.isTranslucent = false
            $0.barTintColor = Palette.whitesmoke
            $0.itemPositioning = .centered
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }

    private func fetchUser() {
        Firebase.fetchUser { user in
            if user?.phoneNumber == nil {
                store.dispatch(action: IAuthRequestsFetchUser(user: user))
            } else {
                store.dispatch(action: IAuthBuddyRequestsFetchUser(user: user))
            }
        }
    }
    
    private func initPrefs() {
        SettingsKt.settings = Prefs()
    }
    
    private func initGoogleMaps() {
        GMSServices.provideAPIKey("AIzaSyAsfEfcMIkgg-dXG1ZEGR56uu7KHcWBBrw")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            store.dispatch(action: AuthRequests.SignIn.Failure(message: error.localizedDescription))
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        store.dispatch(action: AuthRequests.SignIn.WithCredential(credential: credential))
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        GIDSignIn.sharedInstance().handle(url)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    private func registerForPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in })

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }

        AppMiddlewareKt.pushToken = fcmToken
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        DispatchQueue.main.async {
            (self.window?.rootViewController?.presentedViewController as? MainViewController)?.selectedIndex = 4
        }
        completionHandler()
    }
}
