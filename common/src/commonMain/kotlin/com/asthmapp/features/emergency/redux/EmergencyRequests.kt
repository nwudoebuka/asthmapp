package com.asthmapp.features.emergency.redux

import com.asthmapp.features.emergency.Emergency
import com.asthmapp.features.emergency.EmergencyRepository
import com.asthmapp.network.Response
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class EmergencyRequests {

    class StartEmergency(
            private val lat: Double?,
            private val lng: Double?
    ) : Request() {
        private val emergencyRepository = EmergencyRepository()

        override suspend fun execute() {
            val result = when (val response = emergencyRepository.startEmergency(lat, lng)) {
                is Response.Success -> Success(response.result)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val emergency: Emergency) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class GetEmergency : Request() {
        private val emergencyRepository = EmergencyRepository()

        override suspend fun execute() {
            val result = when (val response = emergencyRepository.getEmergency()) {
                is Response.Success -> Success(response.result)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val emergency: Emergency) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class CancelEmergency : Request() {
        private val emergencyRepository = EmergencyRepository()

        override suspend fun execute() {
            val result = when (val response = emergencyRepository.removeEmergency()) {
                is Response.Success -> Success
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        object Success : Action
        data class Failure(override val message: String?) : IToastAction
    }
}
