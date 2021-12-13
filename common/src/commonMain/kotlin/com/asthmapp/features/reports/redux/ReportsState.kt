package com.asthmapp.features.reports.redux

import com.asthmapp.features.reports.ReportItem
import tw.geothings.rekotlin.StateType

data class ReportsState(
        val reports: List<ReportItem> = listOf(),
        val status: Status = Status.IDLE,
        val csv: String? = null
) : StateType {

    enum class Status {
        IDLE, PENDING
    }
}
