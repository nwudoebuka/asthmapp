import UIKit
import TinyConstraints
import common
import PKHUD
import Firebase

class SignInViewController: BaseAuthUIViewController, ReKampStoreSubscriber, UITextFieldDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backButton = UIImageView(image: UIImage(named: "ic_chevron_left")?.withRenderingMode(.alwaysTemplate)).apply {
        $0.tintColor = Palette.ebonyClay
    }
    private let logo = UIImageView().apply {
        $0.image = UIImage(named: "ic_logo")
    }
    private let titleLabel = GiantHeaderLabel().apply {
        $0.text = "welcome".localized
    }
    private let subtitleLabel = SmallHeaderLabel().apply {
        $0.text = "sign_in_with_your_email_address".localized
        $0.textColor = Palette.slateGray
    }
    private let emailTextField = CommonTextField().apply {
        $0.keyboardType = .emailAddress
        $0.autocapitalizationType = .none
        $0.tag = 0
        $0.bind("enter_your_email".localized)
    }
    private let passwordTextField = CommonTextField().apply {
        $0.isSecureTextEntry = true
        $0.tag = 1
        $0.bind("enter_your_password".localized)
    }
    private let forgotPasswordLabel = SmallHeaderLabel().apply {
        $0.attributedText = "forgot_password".localized.underlined
        $0.textColor = Palette.ebonyClay
    }
    private let loginButton = CommonButton().apply {
        $0.setTitle("login".localized.uppercased(), for: .normal)
    }
    private let orView = OrView()

    private let facebookLoginButton = SocialLoginButton(
        .init(
            title: "login_with_facebook".localized,
            image: UIImage(named: "ic_facebook"),
            textColor: Palette.white,
            dividerColor: Palette.white,
            backgroundColor: Palette.indigo
        )
    )

    private let googleLoginButton = SocialLoginButton(
        .init(
            title: "login_with_google".localized,
            image: UIImage(named: "ic_google"),
            textColor: Palette.ebonyClay,
            dividerColor: Palette.ebonyClay.withAlphaComponent(0.5),
            backgroundColor: Palette.white
        )
    )

    private let appleLoginButton = SocialLoginButton(
        .init(
            title: "login_with_apple".localized,
            image: UIImage(named: "ic_apple"),
            textColor: Palette.white,
            dividerColor: Palette.white,
            backgroundColor: Palette.ebonyClay
        )
    ).apply {
        if #available(iOS 13.0, *) {
            $0.isHidden = false
        } else {
            $0.isHidden = true
        }
    }

    private let signUpLabel = SmallHeaderLabel().apply {
        $0.textColor = Palette.ebonyClay
        $0.textAlignment = .center
        $0.attributedText = "new_user".localized.attributed + " ".attributed + "sign_up".localized.colorString(color: Palette.royalBlue)
    }
    private let versionLabel = SmallHeaderLabel().apply {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        $0.text = "version".localizedFormat(args: version)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.auth == newState.auth)
            }.select { state in
                state.auth
            }
        }

        setupView()
    }

    private func setupView() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = Palette.white

        buildViewTree()
        setConstraints()
        setInteractions()
    }

    private func buildViewTree() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, logo, titleLabel, subtitleLabel, emailTextField, passwordTextField, forgotPasswordLabel,
         loginButton, orView, facebookLoginButton, googleLoginButton,
         appleLoginButton, signUpLabel, versionLabel].forEach(contentView.addSubview)
    }

    private func setConstraints() {
        scrollView.edgesToSuperview()
        
        contentView.run {
            $0.edgesToSuperview(insets: .horizontal(20))
            $0.widthToSuperview(offset: -40)
            $0.heightToSuperview(priority: .defaultLow)
        }
        
        backButton.run {
            $0.width(32)
            $0.height(32)
            $0.topToSuperview(offset: 12, usingSafeArea: true)
            $0.leadingToSuperview(offset: -8)
        }
        
        logo.run {
            $0.width(72)
            $0.height(72)
            $0.leadingToSuperview()
            $0.topToBottom(of: backButton, offset: 10)
        }
        
        titleLabel.run {
            $0.horizontalToSuperview()
            $0.topToBottom(of: logo, offset: 16)
        }
        
        subtitleLabel.run {
            $0.topToBottom(of: titleLabel)
            $0.horizontalToSuperview()
        }

        emailTextField.run {
            $0.topToBottom(of: subtitleLabel, offset: 36)
            $0.horizontalToSuperview()
        }

        passwordTextField.run {
            $0.topToBottom(of: emailTextField, offset: 20)
            $0.horizontalToSuperview()
        }
        
        loginButton.run {
            $0.topToBottom(of: passwordTextField, offset: 20)
            $0.horizontalToSuperview()
        }

        forgotPasswordLabel.run {
            $0.topToBottom(of: loginButton, offset: 18)
            $0.trailingToSuperview()
        }

        orView.run {
            $0.centerXToSuperview()
            $0.topToBottom(of: forgotPasswordLabel, offset: 20)
        }

        googleLoginButton.run {
            $0.topToBottom(of: orView, offset: 24)
            $0.height(54)
            $0.horizontalToSuperview()
        }

        facebookLoginButton.run {
            $0.height(54)
            $0.horizontalToSuperview()
            $0.topToBottom(of: googleLoginButton, offset: 16)
        }

        appleLoginButton.run {
            $0.height(54)
            $0.horizontalToSuperview()
            $0.topToBottom(of: facebookLoginButton, offset: 16)
        }

        signUpLabel.run {
            $0.topToBottom(of: appleLoginButton, offset: 26)
            $0.centerXToSuperview()
        }
        versionLabel.run {
            $0.topToBottom(of: signUpLabel, offset: 80)
            $0.centerXToSuperview()
            $0.bottomToSuperview(offset: -16, usingSafeArea: true)
        }
    }

    private func setInteractions() {
        backButton.onTap(target: self, action: #selector(onBackTap))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutside)).apply {
            $0.cancelsTouchesInView = false
        })

        forgotPasswordLabel.run {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didForgotPasswordClick)))
        }

        loginButton.addTarget(self, action: #selector(didLoginClick), for: .touchUpInside)

        facebookLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didFacebookLoginClick)))

        googleLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didGoogleLoginClick)))

        appleLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didAppleLoginClick)))

        signUpLabel.run {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSignUpClick)))
        }
    }
    
    @objc private func onBackTap() {
        dismiss(animated: true)
    }

    @objc private func didForgotPasswordClick() {
        let email = emailTextField.text ?? ""
        SignInController.forgotPassword(email)
    }

    @objc private func didLoginClick() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        SignInController.signInWithEmailAndPassword(email, password)
    }

    @objc private func didFacebookLoginClick() {
        SignInController.signInWithFacebook()
    }

    @objc private func didGoogleLoginClick() {
        SignInController.signInWithGoogle()
    }

    @objc private func didAppleLoginClick() {
        if #available(iOS 13.0, *) {
            SignInController.signInWithApple().run {
                $0.delegate = self
                $0.presentationContextProvider = self
                $0.performRequests()
            }
        }
    }

    @objc private func didSignUpClick() {
        presentModal(SignUpViewController(), withNavigation: false)
    }

    @objc private func didTapOutside(_ tapGestureRecognizer: UITapGestureRecognizer) {
        tapGestureRecognizer.view?.endEditing(true)
    }

    func onNewState(state: Any) {
        let state = state as! AuthState

        switch (state.status) {
        case .success:
            PKHUD.sharedHUD.hide(afterDelay: 0)
            self.dismiss(animated: true)

        case .pending:
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()

        case .idle:
            PKHUD.sharedHUD.hide(afterDelay: 0)
            
        default:
            return
        }

        if (state.status == .success) {
            PKHUD.sharedHUD.hide(afterDelay: 0)
            self.dismiss(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            SignInController.signInWithEmailAndPassword(emailTextField.text ?? "", passwordTextField.text ?? "")
        }

        return false
    }
}
