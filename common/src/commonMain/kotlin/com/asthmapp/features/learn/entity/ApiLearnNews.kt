package com.asthmapp.features.learn.entity

import kotlinx.serialization.Serializable

@Serializable
data class ApiLearnNews(
        val news: List<LearnNews>
)
