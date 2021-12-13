package com.asthmapp.features.home.entity

import kotlinx.serialization.Serializable

@Serializable
data class Buddy(
        val status: Status,
        val phone: String,
        val fullName: String,
        val avatar: String?
) {

    @Serializable
    enum class Status { PENDING, ACCEPTED, REJECTED }
}
