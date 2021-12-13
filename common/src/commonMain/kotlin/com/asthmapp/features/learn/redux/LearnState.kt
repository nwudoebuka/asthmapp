package com.asthmapp.features.learn.redux

import com.asthmapp.features.learn.entity.LearnNews
import tw.geothings.rekotlin.StateType

data class LearnState(
    val allNews: List<LearnNews> = listOf(),
    val filteredNews: List<LearnNews> = listOf()
) : StateType
