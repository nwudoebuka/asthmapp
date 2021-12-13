package com.asthmapp.features.notifications.redux

import com.asthmapp.features.notifications.entity.Notification
import tw.geothings.rekotlin.StateType

data class NotificationsState(
        val notifications: List<Notification> = listOf()
) : StateType
