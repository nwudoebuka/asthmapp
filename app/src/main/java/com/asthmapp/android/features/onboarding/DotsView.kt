package com.asthmapp.android.features.onboarding

import android.content.Context
import android.content.res.ColorStateList
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.core.content.ContextCompat
import androidx.core.widget.ImageViewCompat
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewDotBinding
import com.asthmapp.android.databinding.ViewDotsBinding

class DotsView(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = ViewDotsBinding.inflate(LayoutInflater.from(context), this, true)

    fun configure(totalAmount: Int, indexPassed: Int) = with(binding) {
        repeat(indexPassed) {
            parentLayout.addView(createDot(ContextCompat.getColor(context, R.color.white)))
        }
        repeat(totalAmount - indexPassed) {
            parentLayout.addView(createDot(ContextCompat.getColor(context, R.color.rapit)))
        }
    }

    private fun createDot(
            colorId: Int
    ) = ViewDotBinding.inflate(LayoutInflater.from(context), this, false).apply {
        ImageViewCompat.setImageTintList(image, ColorStateList.valueOf(colorId))
    }.root
}
