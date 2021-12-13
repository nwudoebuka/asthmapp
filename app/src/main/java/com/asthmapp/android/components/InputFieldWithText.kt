package com.asthmapp.android.components

import android.content.Context
import android.text.InputFilter
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.asthmapp.android.databinding.InputFieldWithEditTextBinding
import com.asthmapp.features.add_data.util.IValueValidator

class InputFieldWithText(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = InputFieldWithEditTextBinding.inflate(LayoutInflater.from(context), this, true)

    fun configure(
            text: String,
            hint: String,
            validator: IValueValidator,
            dispatchOnUpdate: (text: String) -> Unit
    ) = with(binding) {
        title.text = text

        val filter = InputFilter { source, _, _, dest, _, _ ->
            val fullText = dest.toString() + source.toString()
            if (validator.isValid(fullText)) {
                dispatchOnUpdate(fullText)
                null
            } else ""
        }

        editText.filters = arrayOf(filter)
        editText.hint = hint
    }
}
