package com.asthmapp.features.auth_buddy.reducers

import com.asthmapp.features.auth_buddy.requests.IAuthBuddyRequests
import com.asthmapp.features.auth_buddy.states.AuthBuddyState
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun authBuddyReducer(action: Action, state: AppState): AuthBuddyState {
    var newState = state.authBuddy
    when (action) {
        is IAuthBuddyRequests.FetchUser -> {
            newState = newState.copy(user = action.user)
        }
        is IAuthBuddyRequests.GetVerificationCode -> {
            newState = newState.copy(getVerificationCodeStatus = AuthBuddyState.Status.PENDING)
        }
        is IAuthBuddyRequests.GetVerificationCode.Success -> {
            newState = newState.copy(
                    getVerificationCodeStatus = AuthBuddyState.Status.SUCCESS,
                    verificationId = action.verificationId
            )
        }
        is IAuthBuddyRequests.GetVerificationCode.Failure -> {
            newState = newState.copy(getVerificationCodeStatus = AuthBuddyState.Status.IDLE)
        }

        is IAuthBuddyRequests.SignInWithCredential -> {
            newState = newState.copy(signInStatus = AuthBuddyState.Status.PENDING)
        }
        is IAuthBuddyRequests.SignInWithCredential.Success -> {
            newState = newState.copy(
                    signInStatus = AuthBuddyState.Status.SUCCESS,
                    user = action.user
            )
        }
        is IAuthBuddyRequests.SignInWithCredential.Failure -> {
            newState = newState.copy(signInStatus = AuthBuddyState.Status.IDLE)
        }
        is IAuthBuddyRequests.Destroy -> {
            newState = AuthBuddyState()
        }
    }
    return newState
}
