package com.asthmapp.features.notifications.entity

import kotlinx.serialization.Serializable

@Serializable
data class Notification(
        val message: String,
        val createdAt: Long,
        val type: Type,
        val link: String?
) {

    @Serializable
    enum class Type {
        QUESTION, SHOP, LEARN_MORE, ADD_DATA, INFO
    }

}
