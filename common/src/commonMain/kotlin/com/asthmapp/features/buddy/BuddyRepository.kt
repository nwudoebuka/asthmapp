package com.asthmapp.features.buddy

import com.asthmapp.network.HttpClientFactory
import com.asthmapp.network.request
import io.ktor.client.*
import io.ktor.client.request.*

internal class BuddyRepository(
        private val httpClient: HttpClient = HttpClientFactory().create(isBuddy = true) // TODO-Yevhenii: Inject with Koin later
) {

    suspend fun getBuddyUsers() = request {
        httpClient.get<BuddyUsersResponse>(path = "buddy")
    }

    suspend fun acceptBuddyRequest(userId: String) = request {
        httpClient.get<BuddyUsersResponse>(path = "buddy/accept") {
            parameter("userId", userId)
        }
    }

    suspend fun rejectBuddyRequest(userId: String) = request {
        httpClient.get<BuddyUsersResponse>(path = "buddy/reject") {
            parameter("userId", userId)
        }
    }
}
