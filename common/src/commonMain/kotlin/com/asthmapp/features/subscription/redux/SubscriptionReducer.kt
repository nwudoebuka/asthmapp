package com.asthmapp.features.subscription.redux

import com.asthmapp.features.subscription.ISubscriptionRequests
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun subscriptionReducer(action: Action, state: AppState): SubscriptionState {
    var newState = state.subscription

    when (action) {
        is ISubscriptionRequests.FetchSubscriptions -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.PENDING
            )
        }
        is ISubscriptionRequests.FetchSubscriptions.Success -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.SUBSCRIBED
            )
        }
        is ISubscriptionRequests.FetchSubscriptions.Failure -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.IDLE
            )
        }
        is ISubscriptionRequests.FetchSkuDetails -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.PENDING
            )
        }
        is ISubscriptionRequests.FetchSkuDetails.Success -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.IDLE,
                    monthlySku = action.monthlySku
            )
        }
        is ISubscriptionRequests.FetchSkuDetails.Failure -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.FAILED,
                    monthlySku = null
            )
        }
        is ISubscriptionRequests.LaunchBillingFlow.Success -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.SUBSCRIBED
            )
        }
        is ISubscriptionRequests.LaunchBillingFlow.Failure -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.FAILED
            )
        }
        is ISubscriptionRequests.Reset -> {
            newState = newState.copy(
                    status = SubscriptionState.Status.IDLE
            )
        }
    }

    return newState
}