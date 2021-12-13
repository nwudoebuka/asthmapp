package com.asthmapp.features.home.entity

import kotlinx.serialization.Serializable

@Serializable
data class Home(
        val alert: Alert?,
        val averagePulse: Indicator?,
        val averageSp02: Indicator?,
        val averagePef: Indicator?,
        val ads: List<Ad>,
        val stats: Stats?,
        val buddies: List<Buddy>,
        val isReminderActivated: Boolean
) {

    @Serializable
    data class Alert(val title: String)

    @Serializable
    data class Ad(
            val title: String,
            val imagePath: String,
            val oldPrice: String,
            val newPrice: String,
            val link: String
    )

    @Serializable
    data class Stats(
            val weeklyPuffs: List<Int>,
            val preventerInhaler: Int,
            val relieverInhaler: Int,
            val combinationInhaler: Int
    )
}
