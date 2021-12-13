package com.asthmapp.features.auth_buddy.states

import com.asthmapp.model.User
import tw.geothings.rekotlin.StateType

data class AuthBuddyState(
        val getVerificationCodeStatus: Status = Status.IDLE,
        val signInStatus: Status = Status.IDLE,
        val user: User? = null,
        val verificationId: String? = null
) : StateType {

    enum class Status { IDLE, PENDING, SUCCESS }
}
