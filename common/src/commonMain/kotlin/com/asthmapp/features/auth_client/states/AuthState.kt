package com.asthmapp.features.auth_client.states

import com.asthmapp.model.User
import tw.geothings.rekotlin.StateType

data class AuthState(
        val status: Status = Status.IDLE,
        val user: User? = null,
        val verifyStatus: Status = Status.IDLE
) : StateType {

    enum class Status { IDLE, PENDING, SUCCESS }
}
