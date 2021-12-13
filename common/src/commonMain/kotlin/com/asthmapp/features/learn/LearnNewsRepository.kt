package com.asthmapp.features.learn

import com.asthmapp.features.learn.entity.ApiLearnNews
import com.asthmapp.network.HttpClientFactory
import com.asthmapp.network.request
import io.ktor.client.*
import io.ktor.client.request.*

internal class LearnNewsRepository(
        private val httpClient: HttpClient = HttpClientFactory().create() // TODO-Yevhenii: Inject with Koin later
) {

    suspend fun getAll() = request {
        httpClient.get<ApiLearnNews>(path = "learn")
    }
}
