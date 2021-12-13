package com.asthmapp.network

import com.asthmapp.redux.store
import io.ktor.client.*
import io.ktor.client.features.*
import io.ktor.client.features.json.*
import io.ktor.client.features.json.serializer.*
import io.ktor.client.features.logging.*
import io.ktor.client.request.*
import io.ktor.http.*

const val BACKEND_LINK = "asthm-app-backend.herokuapp.com"

class HttpClientFactory {

    fun create(isBuddy: Boolean = false) = HttpClient {
        defaultRequest {
            url {
                host = BACKEND_LINK
                protocol = URLProtocol.HTTPS
            }
            header("Authorization", if (isBuddy) bearerBuddyToken else bearerClientToken)
        }
        Json {
            serializer = KotlinxSerializer(
                    json = kotlinx.serialization.json.Json(from = kotlinx.serialization.json.Json.Default) {
                        ignoreUnknownKeys = true
                        useArrayPolymorphism = true
                    }
            )
        }
        Logging {
            logger = Logger.DEFAULT
            level = LogLevel.INFO
        }
    }
}

private val bearerClientToken: String
    get() = "Bearer ${store.state.auth.user?.token}"

private val bearerBuddyToken: String
    get() = "Bearer ${store.state.authBuddy.user?.token}"
