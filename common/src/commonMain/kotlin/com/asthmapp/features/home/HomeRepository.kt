package com.asthmapp.features.home

import com.asthmapp.features.add_data.entity.AddDataBody
import com.asthmapp.features.home.entity.ApiAddBuddy
import com.asthmapp.features.home.entity.BuddiesResponse
import com.asthmapp.features.home.entity.Buddy
import com.asthmapp.features.home.entity.Home
import com.asthmapp.features.reports.GetReportsResponse
import com.asthmapp.features.reports.Period
import com.asthmapp.network.HttpClientFactory
import com.asthmapp.network.request
import com.asthmapp.utils.DateUtils
import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.http.*

internal class HomeRepository(
        private val userHttpClient: HttpClient = HttpClientFactory().create(), // TODO-Yevhenii: Inject with Koin later
        private val buddyHttpClient: HttpClient = HttpClientFactory().create(true) // TODO-Yevhenii: Inject with Koin later
) {

    suspend fun getHome() = request {
        userHttpClient.get<Home>(path = "home") {
            parameter("periodType", Period.Type.WEEK.toString())
            parameter("periodStart", DateUtils().startOfCurrentWeek())
        }
    }

    suspend fun addData(data: AddDataBody) = request {
        userHttpClient.post<Home>(path = "home/add") {
            header(HttpHeaders.ContentType, ContentType.Application.Json)
            parameter("periodType", Period.Type.WEEK.toString())
            parameter("periodStart", DateUtils().startOfCurrentWeek())
            body = data
        }
    }

    suspend fun getReports(period: Period, buddyUserId: String?) = request {
        if (buddyUserId == null) {
            userHttpClient.get<GetReportsResponse>(path = "home/report") {
                parameter("periodType", period.type.toString())
                parameter("periodStart", period.startInMillis)
            }
        } else {
            buddyHttpClient.get(path = "home/report") {
                parameter("periodType", period.type.toString())
                parameter("periodStart", period.startInMillis)
                parameter("buddyUserId", buddyUserId)
            }
        }
    }

    suspend fun addBuddy(buddy: ApiAddBuddy) = request {
        userHttpClient.post<BuddiesResponse>(path = "buddies") {
            header(HttpHeaders.ContentType, ContentType.Application.Json)
            body = buddy
        }
    }

    suspend fun removeBuddy(buddy: Buddy) = request {
        userHttpClient.delete<BuddiesResponse>(path = "buddies") {
            parameter("phone", buddy.phone)
        }
    }

    suspend fun getReportCSV(period: Period) = request {
        userHttpClient.get<String>(path = "home/csv") {
            parameter("periodType", period.type)
            parameter("periodStart", period.startInMillis)
        }
    }
}
