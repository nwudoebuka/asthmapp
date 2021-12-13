package com.asthmapp.android.features.notifications

import com.asthmapp.features.notifications.entity.Notification
import org.ocpsoft.prettytime.PrettyTime
import java.util.*

data class NotificationItem(private val notification: Notification) {
    val message = notification.message
    val time: String = PrettyTime().format(Date(notification.createdAt))
    val type = notification.type
    val link = notification.link
}
