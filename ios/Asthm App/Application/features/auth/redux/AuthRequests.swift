import common
import Firebase

class AuthRequests {

    class SignIn {

        class WithEmailAndPassword: IAuthRequestsSignIn.WithEmailAndPassword {

            override func execute() {
                Firebase.auth.signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        store.dispatch(action: Failure(message: error.localizedDescription))
                        return
                    }

                    Firebase.fetchUser { user in
                        if let user = user {
                            store.dispatch(action: Success(user: user))
                        } else {
                            store.dispatch(action: Failure(message: nil))
                        }
                    }
                }
            }
        }

        class WithCredential: IAuthRequestsSignIn.WithCredential {
            
            private let credential: AuthCredential

            init(credential: AuthCredential) {
                self.credential = credential
            }

            override func execute() {
                Firebase.auth.signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        store.dispatch(action: Failure(message: error.localizedDescription))
                        return
                    }

                    Firebase.fetchUser { user in
                        if let user = user {
                            store.dispatch(action: Success(user: user))
                        } else {
                            store.dispatch(action: Failure(message: nil))
                        }
                    }
                }
            }
        }

        class Success: IAuthRequestsSignIn.Success { }

        class Failure: IAuthRequestsSignIn.Failure { }
    }

    class SignUp: IAuthRequestsSignUp {

        override func execute() {
            Firebase.auth.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    store.dispatch(action: Failure(message: error.localizedDescription))
                    return
                }

                Firebase.fetchUser { user in 
                    if let user = user {
                        store.dispatch(action: Success(user: user))
                    } else {
                        store.dispatch(action: Failure(message: nil))
                    }
                }
            }
        }
        
        class Success: IAuthRequestsSignUp.Success { }

        class Failure: IAuthRequestsSignUp.Failure { }
    }

    class ForgotPassword: IAuthRequestsForgotPassword {

        override func execute() {
            Firebase.auth.sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    store.dispatch(action: Failure(message: error.localizedDescription))
                    return
                }

                store.dispatch(action: Success(message: "forgot_password_success".localized))
            }
        }
        
        class Success: IAuthRequestsForgotPassword.Success { }

        class Failure: IAuthRequestsForgotPassword.Failure { }
    }
    
    class VerifyEmail: IAuthRequestsVerifyEmail {
        
        override func execute() {
            Firebase.auth.currentUser?.sendEmailVerification(completion: { error in
                if let error = error {
                    store.dispatch(action: Failure(message: error.localizedDescription))
                    return
                }
                
                store.dispatch(action: Success())
            })
        }
        
        class Success: IAuthRequestsVerifyEmail.Success { }

        class Failure: IAuthRequestsVerifyEmail.Failure { }
    }
}
