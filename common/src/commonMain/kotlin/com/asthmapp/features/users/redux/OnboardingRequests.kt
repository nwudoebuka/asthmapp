package com.asthmapp.features.users.redux

import com.asthmapp.features.users.UsersRepository
import com.asthmapp.features.users.models.UserUpdateData
import com.asthmapp.network.Response
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class OnboardingRequests {

    data class UpdateData(val data: UserUpdateData) : Request() {

        private val usersRepository = UsersRepository()

        override suspend fun execute() {
            val result = when (val response = usersRepository.updateData(data)) {
                is Response.Success -> Success(response.result)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val fullName: String) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class Next : Request() {

        private val progress = store.state.onboarding.progress

        override suspend fun execute() = when (progress) {
            is OnboardingState.Progress.Start -> store.dispatch(ShowBasicInformation)
            is OnboardingState.Progress.BasicInformation -> store.dispatch(ShowHomePage)
            is OnboardingState.Progress.HomePage -> store.dispatch(ShowLearn)
            is OnboardingState.Progress.Learn -> store.dispatch(ShowBuddy)
            is OnboardingState.Progress.Buddy -> store.dispatch(ShowReport)
            is OnboardingState.Progress.Report -> store.dispatch(ShowNotification)
            is OnboardingState.Progress.Notification -> store.dispatch(ShowRecording)
            is OnboardingState.Progress.Recording -> store.dispatch(ShowEnd)
            is OnboardingState.Progress.End -> store.dispatch(Finish)
            is OnboardingState.Progress.Finished -> throw IllegalStateException()
        }

        object ShowBasicInformation : Action
        object ShowHomePage : Action
        object ShowLearn : Action
        object ShowBuddy : Action
        object ShowReport : Action
        object ShowNotification : Action
        object ShowRecording : Action
        object ShowEnd : Action
        object Finish : Action
    }

    object Destroy : Action
}