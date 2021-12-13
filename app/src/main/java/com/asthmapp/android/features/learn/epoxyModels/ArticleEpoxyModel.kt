package com.asthmapp.android.features.learn.epoxyModels

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewArticleItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.features.add_data.WebViewActivity
import com.asthmapp.android.features.learn.LearnNewsItem
import com.asthmapp.android.util.load

data class ArticleEpoxyModel(private val article: LearnNewsItem.Article) : BaseEpoxyModel(R.layout.view_article_item) {

    init {
        id("ArticleEpoxyModel", article.toString())
    }

    override fun bind(view: View) = with(ViewArticleItemBinding.bind(view)) {
        super.bind(view)
        ivThumbnail.load(article.imageLink)
        tvTime.text = article.title
        tvTime.text = article.readDurationString

        root.setOnClickListener {
            view.context.startActivity(WebViewActivity.newIntent(view.context, article.link, article.title))
        }
    }
}