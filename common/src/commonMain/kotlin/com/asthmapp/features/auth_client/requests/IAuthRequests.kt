package com.asthmapp.features.auth_client.requests

import com.asthmapp.model.User
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.SyncRequest
import tw.geothings.rekotlin.Action

interface IAuthRequests {

    abstract class SignIn {

        abstract class WithEmailAndPassword(val email: String, val password: String) : SyncRequest()
        abstract class WithCredential : SyncRequest()

        abstract class Success(val user: User) : Action
        abstract class Failure(override val message: String?) : IToastAction
    }

    class FetchUser(val user: User?) : Action
    abstract class ForgotPassword(val email: String) : SyncRequest() {

        abstract class Success(override val message: String) : IToastAction
        abstract class Failure(override val message: String?) : IToastAction
    }

    abstract class VerifyEmail : SyncRequest() {

        open class Success : Action
        open class Failure(override val message: String?) : IToastAction
    }

    class DestroyVerifyEmail : Action

    abstract class SignUp(
            val email: String,
            val password: String
    ) : SyncRequest() {

        abstract class Success(val user: User) : Action
        abstract class Failure(override val message: String?) : IToastAction
    }

    class LogOut : Action
}
