package com.asthmapp.android.features.notifications

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.asthmapp.android.R
import com.asthmapp.android.features.SplashActivity
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class NotificationsService : FirebaseMessagingService() {

    private val channelId = "Default"
   lateinit var myNotificationManage:NotificationManager
    override fun onMessageReceived(message: RemoteMessage) {
        val pushNotification = message.data["notification"] ?: return

        val showTaskIntent = Intent(applicationContext, SplashActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        val contentIntent = PendingIntent.getActivity(
                applicationContext,
                0,
                showTaskIntent,
                PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(this, channelId)
                .setContentTitle(getString(R.string.app_name))
                .setContentText(pushNotification)
                .setSmallIcon(R.mipmap.ic_launcher) // TODO-Yevhenii: Update icon
                .setAutoCancel(true)
                .setContentIntent(contentIntent)
                .build()

        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        myNotificationManage = notificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, getString(R.string.default_channel), NotificationManager.IMPORTANCE_DEFAULT)
            notificationManager.createNotificationChannel(channel)
        }
        notificationManager.notify(0, notification)
    }

    override fun onNewToken(newToken: String) {}
}
