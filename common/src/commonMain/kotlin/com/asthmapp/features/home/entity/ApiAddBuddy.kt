package com.asthmapp.features.home.entity

import kotlinx.serialization.Serializable

@Serializable
data class ApiAddBuddy(
        val phone: String,
        val fullName: String,
        val avatar: String?
)
