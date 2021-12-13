package com.asthmapp.features.buddy

import kotlinx.serialization.Serializable

@Serializable
data class BuddyUsersResponse(val buddyUsers: List<BuddyUser>)