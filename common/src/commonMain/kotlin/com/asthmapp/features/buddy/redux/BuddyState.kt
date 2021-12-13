package com.asthmapp.features.buddy.redux

import com.asthmapp.features.buddy.BuddyUser
import tw.geothings.rekotlin.StateType

data class BuddyState(
        val buddyUsers: List<BuddyUser> = listOf(),
        val status: Status = Status.IDLE
) : StateType {

    enum class Status { IDLE, PENDING }
}
