package com.asthmapp.features.buddy

import kotlinx.serialization.Serializable

@Serializable
data class BuddyUser(
        val id: String,
        val fullName: String,
        val status: Status,
        val locationLat: Double?,
        val locationLng: Double?
) {

    @Serializable
    enum class Status { PENDING, ACCEPTED, EMERGENCY }
}
