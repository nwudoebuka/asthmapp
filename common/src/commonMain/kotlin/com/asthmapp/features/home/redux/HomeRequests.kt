package com.asthmapp.features.home.redux

import com.asthmapp.features.home.HomeRepository
import com.asthmapp.features.home.entity.ApiAddBuddy
import com.asthmapp.features.home.entity.Buddy
import com.asthmapp.features.home.entity.Home
import com.asthmapp.network.Response
import com.asthmapp.redux.IAlertAction
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class HomeRequests {

    class FetchHome : Request() {

        private val homeRepository = HomeRepository()

        override suspend fun execute() {
            val result = when (val response = homeRepository.getHome()) {
                is Response.Success -> Success(response.result)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val home: Home) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class AddBuddy(private val buddy: ApiAddBuddy) : Request() {

        private val homeRepository = HomeRepository()

        override suspend fun execute() {
            val result = when (val response = homeRepository.addBuddy(buddy)) {
                is Response.Success -> Success(response.result.buddies)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(
                val buddies: List<Buddy>,
                override val message: String? = "Buddy Invitation Sent"
        ) : IToastAction

        data class Failure(override val message: String?) : IAlertAction
    }

    class RemoveBuddy(private val buddy: Buddy) : Request() {

        private val homeRepository = HomeRepository()

        override suspend fun execute() {
            val result = when (val response = homeRepository.removeBuddy(buddy)) {
                is Response.Success -> Success(response.result.buddies)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val buddies: List<Buddy>) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    object Destroy : Action
}
