package com.asthmapp.features.home.redux

import com.asthmapp.features.home.entity.Buddy
import com.asthmapp.features.home.entity.Home
import com.asthmapp.features.home.entity.Indicator
import tw.geothings.rekotlin.StateType

data class HomeState(
        val alert: Home.Alert? = null,
        val averagePulse: Indicator? = null,
        val averageSp02: Indicator? = null,
        val averagePef: Indicator? = null,
        val ads: List<Home.Ad> = listOf(),
        val stats: Home.Stats? = null,
        val buddies: List<Buddy> = listOf(),
        val isReminderActivated: Boolean = false
) : StateType
