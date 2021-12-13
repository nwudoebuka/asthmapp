package com.asthmapp.android.features.auth_client.redux

import com.asthmapp.android.R
import com.asthmapp.android.appContext
import com.asthmapp.android.firebase.Firebase
import com.asthmapp.features.auth_client.requests.IAuthRequests
import com.asthmapp.model.User
import com.asthmapp.redux.store
import com.google.firebase.auth.AuthCredential

class AuthClientRequests : IAuthRequests {

    class SignIn : IAuthRequests.SignIn() {

        class WithEmailAndPassword(
                email: String, password: String
        ) : IAuthRequests.SignIn.WithEmailAndPassword(email, password) {

            override fun execute() {
                Firebase.auth.signInWithEmailAndPassword(email, password)
                        .addOnCompleteListener { task ->
                            Firebase.fetchUser { user ->
                                user?.let { store.dispatch(Success(it)) }
                                        ?: store.dispatch(Failure(task.exception?.message))
                            }
                        }
            }
        }

        class WithCredential(private val credential: AuthCredential) : IAuthRequests.SignIn.WithCredential() {

            override fun execute() {
                Firebase.auth.signInWithCredential(credential)
                        .addOnCompleteListener { task ->
                            Firebase.fetchUser { user ->
                                user?.let { store.dispatch(Success(it)) }
                                        ?: store.dispatch(Failure(task.exception?.message))
                            }
                        }
            }
        }

        class Success(user: User) : IAuthRequests.SignIn.Success(user)
        class Failure(message: String?) : IAuthRequests.SignIn.Failure(message)
    }

    class ForgotPassword(email: String) : IAuthRequests.ForgotPassword(email) {

        override fun execute() {
            Firebase.auth.sendPasswordResetEmail(email)
                    .addOnCompleteListener { task ->
                        if (task.isSuccessful) {
                            store.dispatch(Success(appContext.getString(R.string.forgot_password_success)))
                        } else {
                            store.dispatch(Failure(task.exception?.message))
                        }
                    }
        }

        class Success(message: String) : IAuthRequests.ForgotPassword.Success(message)
        class Failure(message: String?) : IAuthRequests.ForgotPassword.Failure(message)
    }

    class SignUp(email: String, password: String) : IAuthRequests.SignUp(email, password) {

        override fun execute() {
            Firebase.auth.createUserWithEmailAndPassword(email, password)
                    .addOnCompleteListener { task ->
                        Firebase.fetchUser { user ->
                            user?.let { store.dispatch(Success(it)) }
                                    ?: store.dispatch(Failure(task.exception?.message))
                        }
                    }
        }

        class Success(user: User) : IAuthRequests.SignUp.Success(user)
        class Failure(message: String?) : IAuthRequests.SignUp.Failure(message)
    }

    class VerifyEmail : IAuthRequests.VerifyEmail() {
        override fun execute() {
            Firebase.auth.currentUser?.sendEmailVerification()?.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    store.dispatch(Failure(null))
                } else {
                    store.dispatch(Success())
                }
            }
        }
    }
}
