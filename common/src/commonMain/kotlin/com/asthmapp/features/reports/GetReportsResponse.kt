package com.asthmapp.features.reports

import kotlinx.serialization.Serializable

@Serializable
internal data class GetReportsResponse(
        val reportItems: List<ReportItem>
)
