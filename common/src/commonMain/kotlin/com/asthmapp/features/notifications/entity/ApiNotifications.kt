package com.asthmapp.features.notifications.entity

import kotlinx.serialization.Serializable

@Serializable
data class ApiNotifications(
        val notifications: List<Notification>
)
