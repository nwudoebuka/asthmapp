package com.asthmapp.android.features.components

import android.content.Context
import android.graphics.Typeface
import android.util.AttributeSet
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet.*
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ButtonWithChevronBinding

class ButtonWithChevron(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = ButtonWithChevronBinding.inflate(LayoutInflater.from(context), this, true)

    fun configure(
            buttonText: String,
            mainColorId: Int? = null,
            backgroundColorId: Int? = null,
            iconId: Int? = null,
            textSize: Int? = null,
            isTextAllCaps: Boolean = false,
            isTextCentered: Boolean = false,
            isTextBold: Boolean = false,
            endImageId: Int? = R.drawable.ic_chevron_right,
            onClick: () -> Unit = {}
    ) = with(binding) {
        text.text = buttonText

        textSize?.let {
            text.setTextSize(TypedValue.COMPLEX_UNIT_SP, textSize.toFloat())
        }
        mainColorId?.let {
            text.setTextColor(ContextCompat.getColor(context, mainColorId))
            ivEndImage.setColorFilter(ContextCompat.getColor(context, mainColorId))
        }
        endImageId?.let {
            ivEndImage.visibility = View.VISIBLE
            ivEndImage.setImageDrawable(ContextCompat.getDrawable(context, endImageId))
        } ?: run { ivEndImage.visibility = View.GONE }

        backgroundColorId?.let {
            button.setBackgroundColor(ContextCompat.getColor(context, backgroundColorId))
        }
        iconId?.let {
            icon.setImageDrawable(ContextCompat.getDrawable(context, iconId))
        }
        icon.visibility = if (iconId == null) View.GONE else View.VISIBLE

        if (isTextBold) {
            text.setTypeface(null, Typeface.BOLD)
        } else {
            text.setTypeface(null, Typeface.NORMAL)
        }

        text.isAllCaps = isTextAllCaps
        if (isTextCentered) {
            val params = text.layoutParams as ConstraintLayout.LayoutParams
            params.startToStart = PARENT_ID
            params.marginStart = 0
            params.marginEnd = 0
            params.width = WRAP_CONTENT
            params.endToStart = UNSET
            params.endToEnd = PARENT_ID
            params.marginStart = 0
            params.marginEnd = 0
            text.requestLayout()
        }

        button.setOnClickListener { onClick() }
    }
}
