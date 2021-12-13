package com.asthmapp.features.buddy.redux

import com.asthmapp.features.buddy.BuddyRepository
import com.asthmapp.features.buddy.BuddyUser
import com.asthmapp.network.Response
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class BuddyRequests {

    class FetchBuddyUsers : Request() {

        private val buddyRepository = BuddyRepository()

        override suspend fun execute() {
            val result = when (val response = buddyRepository.getBuddyUsers()) {
                is Response.Success -> Success(response.result.buddyUsers)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val buddyUsers: List<BuddyUser>) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    data class AcceptBuddyRequest(private val userId: String) : Request() {

        private val buddyRepository = BuddyRepository()

        override suspend fun execute() {
            val result = when (val response = buddyRepository.acceptBuddyRequest(userId)) {
                is Response.Success -> Success(response.result.buddyUsers)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val buddyUsers: List<BuddyUser>) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    data class RejectBuddyRequest(private val userId: String) : Request() {

        private val buddyRepository = BuddyRepository()

        override suspend fun execute() {
            val result = when (val response = buddyRepository.rejectBuddyRequest(userId)) {
                is Response.Success -> Success(response.result.buddyUsers)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val buddyUsers: List<BuddyUser>) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    object Destroy : Action
}
