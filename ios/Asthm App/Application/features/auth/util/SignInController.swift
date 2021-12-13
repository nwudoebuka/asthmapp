import common
import Firebase
import GoogleSignIn
import FacebookLogin
import AuthenticationServices

var currentNonce: String?

struct SignInController {

    static func forgotPassword(_ email: String) {
        if (email.isEmpty) {
            store.dispatch(action: AuthRequests.SignIn.Failure(message: "forgot_password_empty_email".localized))
            return
        }

        store.dispatch(action: AuthRequests.ForgotPassword(email: email))
    }

    static func signInWithEmailAndPassword(_ email: String, _ password: String) {
        if (email.isEmpty || password.isEmpty) {
            store.dispatch(action: AuthRequests.SignIn.Failure(message: "fields_can_not_be_empty".localized))
            return
        }

        store.dispatch(action: AuthRequests.SignIn.WithEmailAndPassword(email: email, password: password))
    }
    
    static func signUp(_ email: String, _ password: String, _ confirmPassword: String) {
        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
            store.dispatch(action: AuthRequests.SignUp.Failure(message: "fields_can_not_be_empty".localized))
            return
        }

        if (password != confirmPassword) {
            store.dispatch(action: AuthRequests.SignUp.Failure(message: "passwords_is_not_match".localized))
            return
        }

        store.dispatch(action: AuthRequests.SignUp(email: email, password: password))
    }

    static func signInWithFacebook() {
        LoginManager().logIn { loginResult in
            switch loginResult {
            case .failed(let error):
                store.dispatch(action: AuthRequests.SignIn.Failure(message: error.localizedDescription))
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

                store.dispatch(action: AuthRequests.SignIn.WithCredential(credential: credential))
            }
        }
    }

    static func signInWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }

    @available(iOS 13.0, *)
    static func signInWithApple() -> ASAuthorizationController {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest().apply {
            $0.requestedScopes = [.fullName, .email]
            $0.nonce = sha256(nonce)
        }

        return ASAuthorizationController(authorizationRequests: [request])
    }

    private static func sha256(_ input: String) -> String {
        let data = input.data(using: String.Encoding.utf8)!
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined(separator: "")
    }

    private static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
