package com.asthmapp.features.reports.redux

import com.asthmapp.features.home.HomeRepository
import com.asthmapp.features.reports.Period
import com.asthmapp.features.reports.ReportItem
import com.asthmapp.network.Response
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class ReportsRequests {

    class FetchReports(private val period: Period, private val buddyUserId: String?) : Request() {

        private val homeRepository: HomeRepository = HomeRepository()

        override suspend fun execute() {
            val result = when (val response = homeRepository.getReports(period, buddyUserId)) {
                is Response.Success -> Success(response.result.reportItems)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val reports: List<ReportItem>) : Action
        data class Failure(val error: String?) : Action
    }

    class GetReportCSV(private val period: Period) : Request() {

        private val homeRepository: HomeRepository = HomeRepository()

        override suspend fun execute() {
            val result = when (val response = homeRepository.getReportCSV(period)) {
                is Response.Success -> Success(response.result)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val csv: String) : Action
        data class Failure(val error: String?) : Action
    }

    object DestroyCSV: Action

    object Destroy : Action
}
