package com.asthmapp.features.notifications.redux

import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun notificationsReducer(action: Action, state: AppState): NotificationsState {
    var newState = state.notifications

    when(action) {
        is NotificationsRequests.FetchNotifications.Success -> {
            newState = newState.copy(notifications = action.notifications)
        }
        is NotificationsRequests.DeleteAllNotifications.Success -> {
            newState = newState.copy(notifications = emptyList())
        }
        is NotificationsRequests.Destroy -> {
            newState = NotificationsState()
        }
    }

    return newState
}
