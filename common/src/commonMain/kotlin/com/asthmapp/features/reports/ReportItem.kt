package com.asthmapp.features.reports

import com.asthmapp.features.home.entity.Indicator
import kotlinx.serialization.Serializable

@Serializable
data class ReportItem(
        val period: Period,
        val averageSp02: Indicator,
        val averagePulse: Indicator,
        val averagePef: Indicator,
        val attacks: Indicator,
        val shareLink: String
)
