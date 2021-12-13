package com.asthmapp.features.subscription.redux

import com.asthmapp.features.subscription.Sku
import tw.geothings.rekotlin.StateType

data class SubscriptionState(
        val status: Status = Status.IDLE,
        val monthlySku: Sku? = null,
) : StateType {

    enum class Status { IDLE, PENDING, SUBSCRIBED, FAILED }
}