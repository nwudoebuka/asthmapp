package com.asthmapp.android.components

import android.content.Context
import android.text.InputType
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.inputmethod.EditorInfo
import android.widget.FrameLayout
import android.widget.TextView
import com.asthmapp.android.databinding.InputFieldBinding

class InputField(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    enum class Type {
        EMAIL,
        PASSWORD,
        TEXT,
        TEXT_MULTILINE;

        val textViewInputType: Int
            get() = when (this) {
                EMAIL -> InputType.TYPE_CLASS_TEXT or
                        InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
                PASSWORD -> InputType.TYPE_CLASS_TEXT or
                        InputType.TYPE_TEXT_VARIATION_PASSWORD
                TEXT -> InputType.TYPE_CLASS_TEXT or
                        InputType.TYPE_TEXT_FLAG_CAP_SENTENCES
                TEXT_MULTILINE -> InputType.TYPE_CLASS_TEXT or
                        InputType.TYPE_TEXT_FLAG_MULTI_LINE or
                        InputType.TYPE_TEXT_FLAG_CAP_SENTENCES
            }

        val maxInputLines: Int
            get() = when (this) {
                TEXT_MULTILINE -> Int.MAX_VALUE
                else -> 1
            }
    }

    sealed class Action(
            val imeActionId: Int
    ) {

        open val onClick: (() -> Unit)? = null

        data class Done(
                override val onClick: (() -> Unit)
        ) : Action(EditorInfo.IME_ACTION_DONE)

        data class Go(
                override val onClick: (() -> Unit)
        ) : Action(EditorInfo.IME_ACTION_GO)

        object Next : Action(EditorInfo.IME_ACTION_NEXT)
    }

    private val binding = InputFieldBinding.inflate(LayoutInflater.from(context), this, true)

    fun getEnteredText() = binding.editText.text.trim().toString()

    fun configure(
            inputHint: CharSequence? = null,
            inputHintResId: Int? = null,
            inputText: CharSequence? = null,
            type: Type = Type.TEXT,
            minLines: Int = 1,
            action: Action? = null
    ) = with(binding) {
        editText.hint = when {
            inputHint != null -> inputHint
            inputHintResId != null && inputHintResId != 0 -> resources.getString(inputHintResId)
            else -> null
        }
        editText.setText(inputText ?: "", TextView.BufferType.EDITABLE)
        editText.setSelection(0, editText.text?.length ?: 0)
        editText.inputType = type.textViewInputType
        editText.maxLines = type.maxInputLines
        editText.minLines = minLines
        if (action != null) {
            editText.imeOptions = action.imeActionId
            editText.setOnEditorActionListener { _, actionId, _ ->
                if (actionId == action.imeActionId && action.onClick != null) {
                    action.onClick?.invoke()
                    true
                } else {
                    false
                }
            }
        } else {
            editText.imeOptions = EditorInfo.IME_ACTION_NONE
            editText.setOnEditorActionListener(null)
        }
    }
}
