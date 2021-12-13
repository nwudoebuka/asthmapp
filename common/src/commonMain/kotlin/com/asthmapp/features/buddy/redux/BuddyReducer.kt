package com.asthmapp.features.buddy.redux

import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun buddyReducer(action: Action, state: AppState): BuddyState {
    var newState = state.buddy

    when (action) {
        is BuddyRequests.FetchBuddyUsers -> {
            newState = newState.copy(status = BuddyState.Status.PENDING)
        }

        is BuddyRequests.FetchBuddyUsers.Success -> {
            newState = newState.copy(
                    status = BuddyState.Status.IDLE,
                    buddyUsers = action.buddyUsers
            )
        }

        is BuddyRequests.FetchBuddyUsers.Failure -> {
            newState = newState.copy(status = BuddyState.Status.IDLE)
        }

        is BuddyRequests.AcceptBuddyRequest -> {
            newState = newState.copy(status = BuddyState.Status.PENDING)
        }

        is BuddyRequests.AcceptBuddyRequest.Success -> {
            newState = newState.copy(
                    status = BuddyState.Status.IDLE,
                    buddyUsers = action.buddyUsers
            )
        }

        is BuddyRequests.AcceptBuddyRequest.Failure -> {
            newState = newState.copy(status = BuddyState.Status.IDLE)
        }

        is BuddyRequests.RejectBuddyRequest -> {
            newState = newState.copy(status = BuddyState.Status.PENDING)
        }

        is BuddyRequests.RejectBuddyRequest.Success -> {
            newState = newState.copy(
                    status = BuddyState.Status.IDLE,
                    buddyUsers = action.buddyUsers
            )
        }

        is BuddyRequests.RejectBuddyRequest.Failure -> {
            newState = newState.copy(status = BuddyState.Status.IDLE)
        }

        is BuddyRequests.Destroy -> {
            newState = BuddyState()
        }
    }

    return newState
}
