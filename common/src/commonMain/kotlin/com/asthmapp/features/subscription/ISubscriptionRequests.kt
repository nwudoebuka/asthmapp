package com.asthmapp.features.subscription

import com.asthmapp.redux.SyncRequest
import tw.geothings.rekotlin.Action

interface ISubscriptionRequests {

    abstract class FetchSubscriptions : SyncRequest() {

        object Success : Action
        object Failure : Action
    }

    abstract class FetchSkuDetails : SyncRequest() {

        data class Success(
                val monthlySku: Sku
        ) : Action

        object Failure : Action
    }

    abstract class LaunchBillingFlow : SyncRequest() {

        object Success : Action
        object Failure : Action
    }

    object Reset : Action
}