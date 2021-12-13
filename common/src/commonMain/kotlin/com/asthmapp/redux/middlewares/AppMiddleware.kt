package com.asthmapp.redux.middlewares

import com.asthmapp.features.add_data.redux.AddDataRequests
import com.asthmapp.features.auth_buddy.requests.IAuthBuddyRequests
import com.asthmapp.features.auth_client.requests.IAuthRequests
import com.asthmapp.features.buddy.redux.BuddyRequests
import com.asthmapp.features.home.redux.HomeRequests
import com.asthmapp.features.learn.redux.LearnRequests
import com.asthmapp.features.notifications.redux.NotificationsRequests
import com.asthmapp.features.subscription.ISubscriptionRequests
import com.asthmapp.features.users.redux.OnboardingRequests
import com.asthmapp.redux.Request
import com.asthmapp.redux.SyncRequest
import com.asthmapp.redux.store
import com.asthmapp.utils.settings
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import tw.geothings.rekotlin.Action
import tw.geothings.rekotlin.Middleware
import tw.geothings.rekotlin.StateType

private val scope = MainScope()

var pushToken: String? = null
var fetchSubscriptionsRequestProvider: (() -> ISubscriptionRequests.FetchSubscriptions)? = null

val appMiddleware: Middleware<StateType> = { _, _ ->
    { next ->
        { action ->
            if (action is Request) executeRequest(action)
            if (action is SyncRequest) executeSyncRequest(action)

            addPushTokenOnLogin(action)
            doActionsOnFetchHome(action)
            doActionsOnUserLogOut(action)
            doActionsOnBuddyLogOut(action)
            resetUserOnTokenDeletion(action)
            fetchSubscriptionsOnAuth(action)
            updateIsSubscribedStatus(action)

            next(action)
        }
    }
}

private fun executeRequest(action: Request) = scope.launch { action.execute() }

private fun executeSyncRequest(action: SyncRequest) = scope.launch { action.execute() }

private fun addPushTokenOnLogin(action: Action) = scope.launch {
    if (action is IAuthRequests.SignIn.Success || action is IAuthRequests.SignUp.Success) {
        pushToken?.let { store.dispatch(NotificationsRequests.AddPushToken(it)) }
    }
}

private fun doActionsOnFetchHome(action: Action) = scope.launch {
    val isReminderActivated = when (action) {
        is HomeRequests.FetchHome.Success -> action.home.isReminderActivated
        is AddDataRequests.SubmitData.Success -> action.home.isReminderActivated
        else -> return@launch
    }
    store.dispatch(AddDataRequests.UpdateIsReminderActivated(isReminderActivated))
}

private fun doActionsOnUserLogOut(action: Action) = scope.launch {
    if (action is IAuthRequests.LogOut) {
        store.dispatch(HomeRequests.Destroy)
        store.dispatch(LearnRequests.Destroy)
        store.dispatch(NotificationsRequests.Destroy)
        store.dispatch(OnboardingRequests.Destroy)
        pushToken?.let { store.dispatch(NotificationsRequests.DeletePushToken(it)) }
    }
}

private fun doActionsOnBuddyLogOut(action: Action) = scope.launch {
    if (action is IAuthBuddyRequests.LogOut) {
        store.dispatch(IAuthBuddyRequests.Destroy)
        store.dispatch(BuddyRequests.Destroy)
    }
}

private fun resetUserOnTokenDeletion(action: Action) = scope.launch {
    if (action is NotificationsRequests.DeletePushToken.Success
            || action is NotificationsRequests.DeletePushToken.Failure) {
        store.dispatch(IAuthRequests.FetchUser(null))
    }
}

private fun fetchSubscriptionsOnAuth(action: Action) = scope.launch {
    if ((action is IAuthRequests.FetchUser && action.user != null)
            || action is IAuthRequests.SignIn.Success
            || action is IAuthRequests.SignUp.Success
    ) {
        fetchSubscriptionsRequestProvider?.let {
            store.dispatch(it())
        }
    }
}

private fun updateIsSubscribedStatus(action: Action) = scope.launch {
    when (action) {
        is ISubscriptionRequests.FetchSubscriptions.Success -> settings.putIsSubscribed(true)
        is ISubscriptionRequests.FetchSubscriptions.Failure -> settings.putIsSubscribed(false)
        is ISubscriptionRequests.LaunchBillingFlow.Success -> settings.putIsSubscribed(true)
        is ISubscriptionRequests.LaunchBillingFlow.Failure -> settings.putIsSubscribed(false)
    }
}