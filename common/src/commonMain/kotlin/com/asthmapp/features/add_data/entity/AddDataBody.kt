package com.asthmapp.features.add_data.entity

import kotlinx.serialization.Serializable

@Serializable
data class AddDataBody(
        val sp02: Double?,
        val pulse: Int?,
        val preventerPuffs: Int,
        val relieverPuffs: Int,
        val combinationPuffs: Int,
        val peakExpiratoryFlow: Double?,
        val isReminderActivated: Boolean,
        val scheduledReminder: Long?
)
