package com.asthmapp.features.home.redux

import com.asthmapp.features.add_data.redux.AddDataRequests
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun homeReducer(action: Action, state: AppState): HomeState {
    var newState = state.home

    when (action) {
        is AddDataRequests.SubmitData.Success -> {
            newState = newState.copy(
                    alert = action.home.alert,
                    averagePulse = action.home.averagePulse,
                    averageSp02 = action.home.averageSp02,
                    averagePef = action.home.averagePef,
                    ads = action.home.ads,
                    stats = action.home.stats,
                    buddies = action.home.buddies,
                    isReminderActivated = action.home.isReminderActivated
            )
        }
        is HomeRequests.FetchHome.Success -> {
            newState = newState.copy(
                    alert = action.home.alert,
                    averagePulse = action.home.averagePulse,
                    averageSp02 = action.home.averageSp02,
                    averagePef = action.home.averagePef,
                    ads = action.home.ads,
                    stats = action.home.stats,
                    buddies = action.home.buddies,
                    isReminderActivated = action.home.isReminderActivated
            )
        }
        is HomeRequests.Destroy -> {
            newState = HomeState()
        }
        is HomeRequests.AddBuddy.Success -> {
            newState = newState.copy(buddies = action.buddies)
        }
        is HomeRequests.RemoveBuddy.Success -> {
            newState = newState.copy(buddies = action.buddies)
        }
    }

    return newState
}
