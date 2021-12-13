package com.asthmapp.features.users.redux

import tw.geothings.rekotlin.StateType

data class OnboardingState(
        val submitDataStatus: Status = Status.IDLE,
        val progress: Progress = Progress.Start
) : StateType {

    enum class Status {
        IDLE, PENDING, SUCCESS
    }

    sealed class Progress {

        object Start : Progress()

        object BasicInformation : Progress()

        object HomePage : Progress()

        object Learn : Progress()

        object Buddy : Progress()

        object Report : Progress()

        object Notification : Progress()

        object Recording : Progress()

        object End : Progress()

        object Finished : Progress()
    }
}