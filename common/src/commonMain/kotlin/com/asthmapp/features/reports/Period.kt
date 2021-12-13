package com.asthmapp.features.reports

import kotlinx.serialization.Serializable

@Serializable
data class Period(
        val type: Type,
        val startInMillis: Long
) {

    @Serializable
    enum class Type { DAY, WEEK, MONTH, ALL }
}
