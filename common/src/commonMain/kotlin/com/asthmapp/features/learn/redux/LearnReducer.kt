package com.asthmapp.features.learn.redux

import com.asthmapp.features.learn.entity.LearnNews
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun learnReducer(action: Action, state: AppState): LearnState {
    var newState = state.learn

    when (action) {
        is LearnRequests.FetchNews.Success -> {
            newState = newState.copy(allNews = action.news, filteredNews = action.news)
        }
        is LearnRequests.FilterNews -> {
            newState = newState.copy(filteredNews = newState.allNews.filtered(action.query))
        }
        is LearnRequests.Destroy -> {
            newState = newState.copy(filteredNews = newState.allNews)
        }
    }

    return newState
}

private fun List<LearnNews>.filtered(query: String) = filter {
    val title = when (it) {
        is LearnNews.Video -> it.title
        is LearnNews.Article -> it.title
    }

    return@filter title.toLowerCase().contains(query.toLowerCase())
}
