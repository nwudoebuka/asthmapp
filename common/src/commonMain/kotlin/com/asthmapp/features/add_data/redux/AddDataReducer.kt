package com.asthmapp.features.add_data.redux

import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun addDataReducer(action: Action, state: AppState): AddDataState {
    var newState = state.addData

    when (action) {
        is AddDataRequests.UpdateBloodOxygenLevel -> {
            newState = newState.copy(bloodOxygenLevel = action.value.toIntOrNull())
        }
        is AddDataRequests.UpdatePulse -> {
            newState = newState.copy(pulse = action.value.toIntOrNull())
        }
        is AddDataRequests.UpdateCombinationPuffs -> {
            newState = newState.copy(combinationPuffs = action.value)
        }
        is AddDataRequests.UpdatePreventerPuffs -> {
            newState = newState.copy(preventerPuffs = action.value)
        }
        is AddDataRequests.UpdateRelieverPuffs -> {
            newState = newState.copy(relieverPuffs = action.value)
        }
        is AddDataRequests.UpdatePeakExpiratoryFlow -> {
            newState = newState.copy(peakExpiratoryFlow = action.value.toIntOrNull())
        }
        is AddDataRequests.UpdateIsReminderActivated -> {
            newState = newState.copy(isReminderActivated = action.isActivated)
        }
        is AddDataRequests.UpdateScheduledReminder -> {
            newState = newState.copy(scheduledReminder = action.scheduledReminder)
        }
        is AddDataRequests.SubmitData -> {
            newState = newState.copy(status = AddDataState.Status.PENDING)
        }
        is AddDataRequests.SubmitData.Success -> {
            newState = newState.copy(status = AddDataState.Status.SUBMITTED)
        }
        is AddDataRequests.SubmitData.Failure -> {
            newState = newState.copy(status = AddDataState.Status.IDLE)
        }
        is AddDataRequests.Destroy -> {
            newState = AddDataState(isReminderActivated = state.home.isReminderActivated)
        }
    }
    return newState
}