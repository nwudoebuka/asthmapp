package com.asthmapp.features.users

import com.asthmapp.features.users.models.UserUpdateData
import com.asthmapp.network.HttpClientFactory
import com.asthmapp.network.request
import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.http.*

internal class UsersRepository(
        private val httpClient: HttpClient = HttpClientFactory().create()
) {

    suspend fun updateData(data: UserUpdateData) = request {
        httpClient.put<String>(path = "users") {
            header(HttpHeaders.ContentType, ContentType.Application.Json)
            body = data
        }
    }
}