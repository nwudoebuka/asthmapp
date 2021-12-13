//
//  AuthBuddyRequests.swift
//  Asthm App
//
//  Created by Den Matiash on 15.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import common
import Firebase

class AuthBuddyRequests: IAuthBuddyRequests {
    
    class GetVerificationCode: IAuthBuddyRequestsGetVerificationCode {
        
        override func execute() {
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
                if let error = error {
                    store.dispatch(action: Failure(message: error.localizedDescription))
                    return
                }
                store.dispatch(action: Success(verificationId: verificationId))
            }
        }
    }
    
    private class SignInWithCredential: IAuthBuddyRequestsSignInWithCredential {
        
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
    
    class VerifyCode: IAuthBuddyRequestsVerifyCode {
        
        override func execute() {
            guard let verificationId = store.state.authBuddy.verificationId else {
                store.dispatch(action: Failure(message: nil))
                return
            }
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationId,
                verificationCode: code
            )
            store.dispatch(action: SignInWithCredential(credential: credential))
        }
    }
}
