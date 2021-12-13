package com.asthmapp.features.add_data.redux

import tw.geothings.rekotlin.StateType

data class AddDataState(
        val bloodOxygenLevel: Int? = null,
        val pulse: Int? = null,
        val preventerPuffs: Int = 0,
        val relieverPuffs: Int = 0,
        val combinationPuffs: Int = 0,
        val peakExpiratoryFlow: Int? = null,
        val isReminderActivated: Boolean = false,
        val status: Status = Status.IDLE,
        val scheduledReminder: Long? = null
) : StateType {

    enum class Status {
        IDLE, PENDING, SUBMITTED
    }
}
