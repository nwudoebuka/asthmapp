package com.asthmapp.features.auth_buddy.requests

import com.asthmapp.model.User
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.SyncRequest
import tw.geothings.rekotlin.Action

interface IAuthBuddyRequests {

    class FetchUser(val user: User?) : Action

    abstract class GetVerificationCode(val phoneNumber: String) : SyncRequest() {

        data class Success(val verificationId: String?) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    abstract class SignInWithCredential : SyncRequest() {

        data class Success(val user: User) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    abstract class VerifyCode(val code: String) : SyncRequest() {

        data class Failure(override val message: String?) : IToastAction
    }

    class LogOut : Action

    object Destroy : Action
}
