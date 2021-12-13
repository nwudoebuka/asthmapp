package com.asthmapp.android.features.auth_buddy.redux

import android.app.Activity
import com.asthmapp.android.R
import com.asthmapp.android.appContext
import com.asthmapp.android.firebase.Firebase
import com.asthmapp.android.firebase.Firebase.auth
import com.asthmapp.features.auth_buddy.requests.IAuthBuddyRequests
import com.asthmapp.redux.store
import com.google.firebase.FirebaseException
import com.google.firebase.auth.PhoneAuthCredential
import com.google.firebase.auth.PhoneAuthOptions
import com.google.firebase.auth.PhoneAuthProvider
import java.util.concurrent.TimeUnit

class AuthBuddyRequests : IAuthBuddyRequests {

    class GetVerificationCode(
            private val activity: Activity,
            phoneNumber: String
    ) : IAuthBuddyRequests.GetVerificationCode(phoneNumber) {

        override fun execute() {
            if (phoneNumber.isEmpty()) {
                store.dispatch(Failure(appContext.resources.getString(R.string.phone_number_should_not_be_empty)))
                return
            }
            val options = PhoneAuthOptions.newBuilder(auth)
                    .setPhoneNumber(phoneNumber)
                    .setTimeout(30L, TimeUnit.SECONDS)
                    .setActivity(activity)
                    .setCallbacks(object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {

                        override fun onCodeSent(
                                verificationId: String,
                                forceResendingToken: PhoneAuthProvider.ForceResendingToken
                        ) {
                            store.dispatch(Success(verificationId))
                            AuthBuddyRequests.forceResendingToken = forceResendingToken
                        }

                        override fun onVerificationCompleted(phoneAuthCredential: PhoneAuthCredential) {
                            store.dispatch(SignInWithPhoneAuthCredential(phoneAuthCredential))
                        }

                        override fun onVerificationFailed(e: FirebaseException) {
                            store.dispatch(Failure(e.message))
                        }
                    })
            if (forceResendingToken != null) {
                PhoneAuthProvider.verifyPhoneNumber(options.setForceResendingToken(forceResendingToken!!).build())
            } else {
                PhoneAuthProvider.verifyPhoneNumber(options.build())
            }
        }
    }

    private class SignInWithPhoneAuthCredential(
            private val credential: PhoneAuthCredential
    ) : IAuthBuddyRequests.SignInWithCredential() {

        override fun execute() {
            auth.signInWithCredential(credential)
                    .addOnCompleteListener { task ->
                        Firebase.fetchUser { user ->
                            user?.let { store.dispatch(Success(it)) }
                                    ?: store.dispatch(Failure(task.exception?.message))
                        }
                    }
        }
    }

    class VerifyCode(code: String) : IAuthBuddyRequests.VerifyCode(code) {

        override fun execute() {
            val verificationId = store.state.authBuddy.verificationId
            verificationId?.let {
                val credential = PhoneAuthProvider.getCredential(verificationId, code)
                store.dispatch(SignInWithPhoneAuthCredential(credential))
            } ?: run {
                store.dispatch(Failure(null))
            }
        }
    }

    companion object {

        private var forceResendingToken: PhoneAuthProvider.ForceResendingToken? = null
    }
}
