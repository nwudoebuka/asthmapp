package com.asthmapp.features.notifications.redux

import com.asthmapp.features.notifications.NotificationsRepository
import com.asthmapp.features.notifications.entity.Notification
import com.asthmapp.network.Response
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class NotificationsRequests {

    class FetchNotifications : Request() {

        private val notificationsRepository = NotificationsRepository()

        override suspend fun execute() {
            val result = when (val response = notificationsRepository.getAll()) {
                is Response.Success -> Success(response.result.notifications)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val notifications: List<Notification>) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class DeleteAllNotifications : Request() {

        private val notificationsRepository = NotificationsRepository()

        override suspend fun execute() {
            val result = when (val response = notificationsRepository.deleteAll()) {
                is Response.Success -> Success
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        object Success : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class AddPushToken(
            private val pushToken: String
    ) : Request() {

        private val notificationsRepository = NotificationsRepository()

        override suspend fun execute() {
            val result = when (val response = notificationsRepository.addPushToken(pushToken)) {
                is Response.Success -> Success
                is Response.Failure -> DeletePushToken.Failure(response.error)
            }
            store.dispatch(result)
        }

        object Success : Action
        data class Failure(override val message: String?) : IToastAction
    }

    class DeletePushToken(
            private val pushToken: String
    ) : Request() {

        private val notificationsRepository = NotificationsRepository()

        override suspend fun execute() {
            val result = when (val response = notificationsRepository.deletePushToken(pushToken)) {
                is Response.Success -> Success
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        object Success : Action
        data class Failure(override val message: String?) : IToastAction
    }

    object Destroy : Action
}
