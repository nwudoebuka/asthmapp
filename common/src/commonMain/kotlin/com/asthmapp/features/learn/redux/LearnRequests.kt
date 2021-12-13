package com.asthmapp.features.learn.redux

import com.asthmapp.features.learn.LearnNewsRepository
import com.asthmapp.features.learn.entity.LearnNews
import com.asthmapp.network.Response
import com.asthmapp.redux.IToastAction
import com.asthmapp.redux.Request
import com.asthmapp.redux.store
import tw.geothings.rekotlin.Action

class LearnRequests {

    class FetchNews : Request() {

        private val learnNewsRepository = LearnNewsRepository()

        override suspend fun execute() {
            val result = when (val response = learnNewsRepository.getAll()) {
                is Response.Success -> Success(response.result.news)
                is Response.Failure -> Failure(response.error)
            }
            store.dispatch(result)
        }

        data class Success(val news: List<LearnNews>) : Action
        data class Failure(override val message: String?) : IToastAction
    }

    data class FilterNews(val query: String) : Action
    object Destroy : Action
}
