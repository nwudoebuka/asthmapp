package com.asthmapp.android.features.home

import android.graphics.Paint
import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewAdItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.features.add_data.WebViewActivity
import com.asthmapp.android.util.load
import com.asthmapp.features.home.entity.Home

data class AdEpoxyModel(private val ad: Home.Ad) : BaseEpoxyModel(R.layout.view_ad_item) {

    init {
        id("AdEpoxyModel", ad.toString())
    }

    override fun bind(view: View) = with(ViewAdItemBinding.bind(view)) {
        super.bind(view)
        ivWatch.load(ad.imagePath)
        tvDescription.text = ad.title
        tvOldPrice.text = ad.oldPrice
        tvNewPrice.text = ad.newPrice
        tvOldPrice.paintFlags = Paint.STRIKE_THRU_TEXT_FLAG

        root.setOnClickListener {
            view.context.startActivity(WebViewActivity.newIntent(view.context, ad.link, ad.title))
        }
    }
}