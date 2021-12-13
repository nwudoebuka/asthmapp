package com.asthmapp.utils

import kotlinx.datetime.*

class DateUtils {
    fun startOfCurrentWeek(): Long {
        val now = Clock.System.now()

        val timeZone = TimeZone.currentSystemDefault()
        val localDateTime = now.toLocalDateTime(timeZone)

        return now.minus(localDateTime.dayOfWeek.isoDayNumber - 1, DateTimeUnit.DAY, timeZone)
                .minus(localDateTime.hour, DateTimeUnit.HOUR, timeZone)
                .minus(localDateTime.minute, DateTimeUnit.MINUTE, timeZone)
                .minus(localDateTime.second, DateTimeUnit.SECOND, timeZone)
                .toEpochMilliseconds()
    }
}