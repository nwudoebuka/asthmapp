package com.asthmapp.features.notifications

import com.asthmapp.features.notifications.entity.ApiNotifications
import com.asthmapp.network.HttpClientFactory
import com.asthmapp.network.request
import io.ktor.client.*
import io.ktor.client.request.*

internal class NotificationsRepository(
        private val httpClient: HttpClient = HttpClientFactory().create()
) {

    suspend fun getAll() = request {
        httpClient.get<ApiNotifications>(path = "notifications")
    }

    suspend fun deleteAll() = request {
        httpClient.delete<Unit>(path = "notifications")
    }

    suspend fun addPushToken(token: String) = request {
        httpClient.put<Unit>(path = "notifications/token?token=$token")
    }

    suspend fun deletePushToken(token: String) = request {
        httpClient.delete<Unit>(path = "notifications/token?token=$token")
    }
}
