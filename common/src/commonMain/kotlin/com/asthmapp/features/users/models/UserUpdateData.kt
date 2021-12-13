package com.asthmapp.features.users.models

import kotlinx.serialization.Serializable

@Serializable
data class UserUpdateData(
        val fullName: String,
        val birthdate: Long,
        val height: Int,
        val gender: Gender
)
