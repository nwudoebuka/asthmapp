package com.asthmapp.features.home.entity

import kotlinx.serialization.Serializable

@Serializable
data class Indicator(
        val value: Int,
        val level: Level
) {

    @Serializable
    enum class Level { NORMAL, ALERT }
}
