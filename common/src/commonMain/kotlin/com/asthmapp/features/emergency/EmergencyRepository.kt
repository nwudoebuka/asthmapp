package com.asthmapp.features.emergency

import com.asthmapp.network.HttpClientFactory
import com.asthmapp.network.request
import io.ktor.client.*
import io.ktor.client.request.*

internal class EmergencyRepository(
        private val httpClient: HttpClient = HttpClientFactory().create() // TODO-Yevhenii: Inject with Koin later
) {

    suspend fun getEmergency() = request {
        httpClient.get<Emergency>(path = "emergency")
    }

    suspend fun startEmergency(lat: Double?, lng: Double?) = request {
        httpClient.post<Emergency>(path = "emergency") {
            parameter("lat", lat)
            parameter("lng", lng)
        }
    }

    suspend fun removeEmergency() = request {
        httpClient.delete<Unit>(path = "emergency")
    }
}
