package com.asthmapp.features.add_data.redux

import com.asthmapp.features.add_data.entity.AddDataBody
import com.asthmapp.features.home.HomeRepository
import com.asthmapp.features.home.entity.Home
import com.asthmapp.network.Response
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class AddDataRequests {

    data class UpdateBloodOxygenLevel(val value: String) : Action
    data class UpdatePulse(val value: String) : Action
    data class UpdatePreventerPuffs(val value: Int) : Action
    data class UpdateRelieverPuffs(val value: Int) : Action
    data class UpdateCombinationPuffs(val value: Int) : Action
    data class UpdatePeakExpiratoryFlow(val value: String) : Action
    data class UpdateIsReminderActivated(val isActivated: Boolean) : Action
    data class UpdateScheduledReminder(val scheduledReminder: Long) : Action

    object Destroy : Action

    class SubmitData : Request() {

        private val homeRepository: HomeRepository = HomeRepository()

        override suspend fun execute() {
            val state = store.state.addData

            val result = when (val response = homeRepository.addData(buildAddDataBody(state))) {
                is Response.Success -> Success(response.result)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        private fun buildAddDataBody(state: AddDataState) = AddDataBody(
                combinationPuffs = state.combinationPuffs,
                preventerPuffs = state.preventerPuffs,
                relieverPuffs = state.relieverPuffs,
                isReminderActivated = state.isReminderActivated,
                pulse = state.pulse,
                peakExpiratoryFlow = state.peakExpiratoryFlow?.toDouble(),
                sp02 = state.bloodOxygenLevel?.toDouble(),
                scheduledReminder = state.scheduledReminder
        )

        data class Success(val home: Home) : Action
        data class Failure(override val message: String?) : IToastAction
    }
}
