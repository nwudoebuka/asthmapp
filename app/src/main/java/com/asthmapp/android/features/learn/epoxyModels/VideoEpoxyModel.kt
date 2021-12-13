package com.asthmapp.android.features.learn.epoxyModels

import android.content.Intent
import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewVideoItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.features.learn.LearnNewsItem
import com.asthmapp.android.util.load
import com.google.android.youtube.player.YouTubePlayer
import com.thefinestartist.ytpa.YouTubePlayerActivity
import com.thefinestartist.ytpa.enums.Orientation
import com.thefinestartist.ytpa.utils.YouTubeUrlParser

data class VideoEpoxyModel(private val video: LearnNewsItem.Video) : BaseEpoxyModel(R.layout.view_video_item) {

    init {
        id("VideoEpoxyModel", video.toString())
    }

    override fun bind(view: View) = with(ViewVideoItemBinding.bind(view)) {
        super.bind(view)

        ivThumbnail.load(video.imageLink)
        tvTitle.text = video.title
        tvTime.text = video.durationString

        root.setOnClickListener {
            val intent = Intent(view.context, YouTubePlayerActivity::class.java).apply {
                val videoId = YouTubeUrlParser.getVideoId(video.link)
                putExtra(YouTubePlayerActivity.EXTRA_VIDEO_ID, videoId)
                putExtra(YouTubePlayerActivity.EXTRA_PLAYER_STYLE, YouTubePlayer.PlayerStyle.DEFAULT)
                putExtra(YouTubePlayerActivity.EXTRA_ORIENTATION, Orientation.AUTO)
                putExtra(YouTubePlayerActivity.EXTRA_SHOW_AUDIO_UI, true)
                putExtra(YouTubePlayerActivity.EXTRA_HANDLE_ERROR, true)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            view.context.startActivity(intent)
        }
    }
}