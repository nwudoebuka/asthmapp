package com.asthmapp.features.users.redux

import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun onboardingReducer(action: Action, state: AppState): OnboardingState {
    var newState = state.onboarding

    when (action) {
        is OnboardingRequests.UpdateData -> {
            newState = newState.copy(submitDataStatus = OnboardingState.Status.PENDING)
        }
        is OnboardingRequests.UpdateData.Success -> {
            newState = newState.copy(submitDataStatus = OnboardingState.Status.SUCCESS)
        }
        is OnboardingRequests.UpdateData.Failure -> {
            newState = newState.copy(submitDataStatus = OnboardingState.Status.IDLE)
        }

        is OnboardingRequests.Next.ShowBasicInformation -> {
            newState = newState.copy(progress = OnboardingState.Progress.BasicInformation)
        }
        is OnboardingRequests.Next.ShowHomePage -> {
            newState = newState.copy(progress = OnboardingState.Progress.HomePage)
        }
        is OnboardingRequests.Next.ShowLearn -> {
            newState = newState.copy(progress = OnboardingState.Progress.Learn)
        }
        is OnboardingRequests.Next.ShowBuddy -> {
            newState = newState.copy(progress = OnboardingState.Progress.Buddy)
        }
        is OnboardingRequests.Next.ShowReport -> {
            newState = newState.copy(progress = OnboardingState.Progress.Report)
        }
        is OnboardingRequests.Next.ShowNotification -> {
            newState = newState.copy(progress = OnboardingState.Progress.Notification)
        }
        is OnboardingRequests.Next.ShowRecording -> {
            newState = newState.copy(progress = OnboardingState.Progress.Recording)
        }
        is OnboardingRequests.Next.ShowEnd -> {
            newState = newState.copy(progress = OnboardingState.Progress.End)
        }
        is OnboardingRequests.Next.Finish -> {
            newState = newState.copy(progress = OnboardingState.Progress.Finished)
        }
        is OnboardingRequests.Destroy -> {
            newState = OnboardingState()
        }
    }
    return newState
}