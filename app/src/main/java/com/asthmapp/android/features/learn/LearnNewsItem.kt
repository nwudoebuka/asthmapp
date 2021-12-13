package com.asthmapp.android.features.learn

import com.asthmapp.android.R
import com.asthmapp.android.appContext
import com.asthmapp.features.learn.entity.LearnNews

sealed class LearnNewsItem {

    data class Video(private val video: LearnNews.Video) : LearnNewsItem() {

        val title = video.title
        val link = video.link
        val imageLink = video.imageLink
        val durationString = video.durationSeconds.toDurationString()

        private fun Int.toDurationString(): String {
            val seconds = (this % 60).toString().padStart(2, '0')
            val minutes = (this / 60).toString().padStart(2, '0')
            return "$minutes:$seconds"
        }
    }

    data class Article(private val article: LearnNews.Article) : LearnNewsItem() {

        val title = article.title
        val link = article.link
        val imageLink = article.imageLink
        val readDurationString = article.readTimeSeconds.toReadDurationString()

        private fun Int.toReadDurationString() = appContext.getString(R.string.article_read, this / 60)
    }
}
