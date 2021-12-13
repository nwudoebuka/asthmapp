package com.asthmapp.features.auth_client.reducers

import com.asthmapp.features.auth_client.requests.IAuthRequests
import com.asthmapp.features.auth_client.states.AuthState
import com.asthmapp.features.users.redux.OnboardingRequests
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun authReducer(action: Action, state: AppState): AuthState {
    var newState = state.auth

    when (action) {
        is IAuthRequests.SignIn.WithEmailAndPassword -> {
            newState = newState.copy(
                    status = AuthState.Status.PENDING
            )
        }
        is IAuthRequests.SignIn.WithCredential -> {
            newState = newState.copy(
                    status = AuthState.Status.PENDING
            )
        }
        is IAuthRequests.SignIn.Success -> {
            newState = newState.copy(
                    status = AuthState.Status.SUCCESS,
                    user = action.user
            )
        }
        is IAuthRequests.SignIn.Failure -> {
            newState = newState.copy(
                    status = AuthState.Status.IDLE
            )
        }

        is IAuthRequests.FetchUser -> {
            newState = newState.copy(
                    user = action.user,
                    status = if (action.user != null) AuthState.Status.SUCCESS else AuthState.Status.IDLE
            )
        }

        is IAuthRequests.SignUp -> {
            newState = newState.copy(
                    status = AuthState.Status.PENDING
            )
        }

        is IAuthRequests.SignUp.Success -> {
            newState = newState.copy(
                    status = AuthState.Status.SUCCESS,
                    user = action.user
            )
        }
        is IAuthRequests.SignUp.Failure -> {
            newState = newState.copy(
                    status = AuthState.Status.IDLE
            )
        }
        is IAuthRequests.VerifyEmail -> {
            newState = newState.copy(
                    verifyStatus = AuthState.Status.PENDING
            )
        }
        is IAuthRequests.VerifyEmail.Success -> {
            newState = newState.copy(
                    verifyStatus = AuthState.Status.SUCCESS
            )
        }
        is IAuthRequests.VerifyEmail.Failure -> {
            newState = newState.copy(
                    verifyStatus = AuthState.Status.IDLE
            )
        }
        is IAuthRequests.DestroyVerifyEmail -> {
            newState = newState.copy(
                    verifyStatus = AuthState.Status.IDLE
            )
        }
        is OnboardingRequests.UpdateData.Success -> {
            newState = newState.copy(
                    user = newState.user?.copy(name = action.fullName)
            )
        }
    }

    return newState
}
