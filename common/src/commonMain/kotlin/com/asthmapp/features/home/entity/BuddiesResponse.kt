package com.asthmapp.features.home.entity

import kotlinx.serialization.Serializable

@Serializable
internal data class BuddiesResponse(
        val buddies: List<Buddy>
)
