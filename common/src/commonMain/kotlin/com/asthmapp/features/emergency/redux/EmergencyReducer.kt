package com.asthmapp.features.emergency.redux

import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun emergencyReducer(action: Action, state: AppState): EmergencyState {
    var newState = state.emergency

    when (action) {
        is EmergencyRequests.StartEmergency.Success -> {
            newState = newState.copy(emergency = action.emergency)
        }
        is EmergencyRequests.GetEmergency.Success -> {
            newState = newState.copy(emergency = action.emergency)
        }
        is EmergencyRequests.GetEmergency.Failure -> {
            newState = newState.copy(emergency = null)
        }
        is EmergencyRequests.CancelEmergency.Success -> {
            newState = newState.copy(emergency = null)
        }
    }

    return newState
}
