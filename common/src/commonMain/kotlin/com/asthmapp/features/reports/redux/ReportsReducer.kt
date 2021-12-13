package com.asthmapp.features.reports.redux

import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun reportsReducer(action: Action, state: AppState): ReportsState {
    var newState = state.reports

    when (action) {
        is ReportsRequests.FetchReports -> {
            newState = newState.copy(
                    status = ReportsState.Status.PENDING,
                    reports = listOf()
            )
        }
        is ReportsRequests.FetchReports.Success -> {
            newState = newState.copy(
                    reports = action.reports,
                    status = ReportsState.Status.IDLE
            )
        }
        is ReportsRequests.FetchReports.Failure -> {
            newState = newState.copy(
                    status = ReportsState.Status.IDLE
            )
        }

        is ReportsRequests.Destroy -> {
            newState = ReportsState()
        }

        is ReportsRequests.GetReportCSV -> {
            newState = newState.copy(status = ReportsState.Status.PENDING)
        }

        is ReportsRequests.GetReportCSV.Success -> {
            newState = newState.copy(
                    status = ReportsState.Status.IDLE,
                    csv = action.csv
            )
        }

        is ReportsRequests.GetReportCSV.Failure -> {
            newState = newState.copy(status = ReportsState.Status.IDLE)
        }

        is ReportsRequests.DestroyCSV -> {
            newState = newState.copy(csv = null)
        }
    }

    return newState
}
