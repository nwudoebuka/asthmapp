package com.asthmapp.android.util

import android.widget.ImageView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy

fun ImageView.load(imageUrl: String) = Glide.with(this)
        .load(imageUrl)
        .diskCacheStrategy(DiskCacheStrategy.NONE)
        .into(this)