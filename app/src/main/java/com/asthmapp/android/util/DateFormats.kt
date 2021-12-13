package com.asthmapp.android.util

import com.asthmapp.utils.Constants
import java.text.SimpleDateFormat
import java.util.*

object DateFormats {
    fun formatWeekFromMillis(
            millis: Long,
            divider: String = "\n",
            showFullMonth: Boolean = false
    ): String {
        val time = Calendar.getInstance()
        time.timeInMillis = millis
        val firstDay = time.get(Calendar.DAY_OF_MONTH)
        time.timeInMillis = millis + 6 * Constants.AMOUNT_OF_MILLISECONDS_IN_DAY
        val lastDay = time.get(Calendar.DAY_OF_MONTH)

        val dateFormat = SimpleDateFormat(if (showFullMonth) "MMMM" else "MMM", Locale.getDefault())

        val month = dateFormat.format(Date(millis))

        return "$firstDay - $lastDay${divider}$month"
    }

    val monthFormat = SimpleDateFormat("MMMM yyyy", Locale.getDefault())
    val dayFormat = SimpleDateFormat("EEEE, d MMMM", Locale.getDefault())
}