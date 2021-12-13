import UIKit
import TinyConstraints
import common
import PKHUD

class SignUpViewController: BaseAuthUIViewController, ReKampStoreSubscriber, UITextFieldDelegate {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let logo = UIImageView().apply {
        $0.image = UIImage(named: "ic_logo")
    }
    private let titleLabel = GiantHeaderLabel().apply {
        $0.text = "welcome".localized
    }
    private let subtitleLabel = SmallHeaderLabel().apply {
        $0.text = "sign_up_explanation".localized
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
    private let confirmPasswordTextField = CommonTextField().apply {
        $0.isSecureTextEntry = true
        $0.tag = 2
        $0.bind("confirm_password".localized)
    }
    private let signUpButton = CommonButton().apply {
        $0.setTitle("continue".localized.uppercased(), for: .normal)
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

    private let signInLabel = SmallHeaderLabel().apply {
        $0.textColor = Palette.ebonyClay
        $0.textAlignment = .center
        $0.attributedText = "already_have_an_account".localized.attributed + " ".attributed + "sign_in".localized.colorString(color: Palette.royalBlue)
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
        [emailTextField, confirmPasswordTextField, passwordTextField].forEach { $0.delegate = self }

        view.backgroundColor = Palette.white
        
        buildViewTree()
        setConstraints()
        setInteractions()
    }

    private func buildViewTree() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [logo, titleLabel, subtitleLabel, emailTextField, passwordTextField, confirmPasswordTextField,
         signUpButton, orView, facebookLoginButton, googleLoginButton,
         appleLoginButton, signInLabel, versionLabel].forEach(contentView.addSubview)
    }

    private func setConstraints() {
        scrollView.edgesToSuperview()
        
        contentView.run {
            $0.edgesToSuperview(insets: .horizontal(20))
            $0.widthToSuperview(offset: -40)
            $0.heightToSuperview(priority: .defaultLow)
        }
        
        logo.run {
            $0.width(72)
            $0.height(72)
            $0.leadingToSuperview()
            $0.topToSuperview(offset: 40)
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
        
        confirmPasswordTextField.run {
            $0.topToBottom(of: passwordTextField, offset: 20)
            $0.horizontalToSuperview()
        }
        
        signUpButton.run {
            $0.topToBottom(of: confirmPasswordTextField, offset: 20)
            $0.horizontalToSuperview()
        }

        orView.run {
            $0.centerXToSuperview()
            $0.topToBottom(of: signUpButton, offset: 20)
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

        signInLabel.run {
            $0.topToBottom(of: appleLoginButton, offset: 26)
            $0.centerXToSuperview()
        }
        versionLabel.run {
            $0.topToBottom(of: signInLabel, offset: 80)
            $0.centerXToSuperview()
            $0.bottomToSuperview(offset: -16, usingSafeArea: true)
        }
    }

    private func setInteractions() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutside)).apply {
            $0.cancelsTouchesInView = false
        })

        signUpButton.addTarget(self, action: #selector(didSignUpClick), for: .touchUpInside)

        signInLabel.run {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSignInClick)))
        }
        
        facebookLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didFacebookLoginClick)))

        googleLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didGoogleLoginClick)))

        appleLoginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didAppleLoginClick)))
    }

    @objc func didSignUpClick(_ sender: UIButton) {
        performSignUp()
    }

    private func performSignUp() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        SignInController.signUp(email, password, confirmPassword)
    }
    
    @objc func didFacebookLoginClick() {
        SignInController.signInWithFacebook()
    }

    @objc func didGoogleLoginClick() {
        SignInController.signInWithGoogle()
    }

    @objc func didAppleLoginClick() {
        if #available(iOS 13.0, *) {
            SignInController.signInWithApple().run {
                $0.delegate = self
                $0.presentationContextProvider = self
                $0.performRequests()
            }
        }
    }

    @objc func didSignInClick(recognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @objc func didTapOutside(_ tapGestureRecognizer: UITapGestureRecognizer) {
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
            performSignUp()
        }

        return false
    }
}
