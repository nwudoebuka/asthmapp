package com.asthmapp.features.emergency

import kotlinx.serialization.Serializable

@Serializable
data class Emergency(
        val status: Status
) {

    @Serializable
    enum class Status { SMS_TO_BUDDIES, AWAITING_CALLS, CALLING_EMERGENCY, CANCELLED }
}
