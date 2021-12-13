package com.asthmapp.model

data class User(
        val id: String,
        val token: String,
        val photoUrl: String?,
        val name: String?,
        val email: String?,
        val isEmailVerified: Boolean,
        val phoneNumber: String?
)
