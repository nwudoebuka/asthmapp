package com.asthmapp.features.learn.entity

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
sealed class LearnNews {

    @Serializable
    @SerialName("video")
    data class Video(
            val title: String,
            val durationSeconds: Int,
            val imageLink: String,
            val link: String,
            val publishedAt: Long
    ) : LearnNews()

    @Serializable
    @SerialName("article")
    data class Article(
            val title: String,
            val readTimeSeconds: Int,
            val imageLink: String,
            val link: String,
            val publishedAt: Long
    ) : LearnNews()
}
