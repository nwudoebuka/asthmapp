package com.asthmapp.android.features.components

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.core.content.ContextCompat
import com.asthmapp.android.databinding.SocialButtonBinding

class SocialButton(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = SocialButtonBinding.inflate(LayoutInflater.from(context), this, true)

    fun configure(
            iconResId: Int,
            textResId: Int,
            textColorId: Int,
            backgroundColorId: Int
    ) = with(binding) {
        button.setBackgroundColor(ContextCompat.getColor(context, backgroundColorId))
        text.setText(textResId)
        icon.setImageResource(iconResId)
        text.setTextColor(ContextCompat.getColor(context, textColorId))
    }

    fun addOnClickListener(onClickListener: () -> Unit) {
        binding.button.setOnClickListener { onClickListener() }
    }
}
