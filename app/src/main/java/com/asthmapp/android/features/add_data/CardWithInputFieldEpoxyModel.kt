package com.asthmapp.android.features.add_data

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewCardWithInputFieldItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.features.add_data.util.IValueValidator

data class CardWithInputFieldEpoxyModel(
        private val title: String,
        private val hint: String,
        private val linkText: CharSequence? = null,
        private val linkUrl: String? = null,
        private val inputTextTitle: String,
        private val validator: IValueValidator,
        private val dispatchOnUpdate: (text: String) -> Unit
) : BaseEpoxyModel(R.layout.view_card_with_input_field_item) {

    init {
        id("CardWithInputFieldEpoxyModel", hashCode().toString())
    }

    override fun bind(view: View) = with(ViewCardWithInputFieldItemBinding.bind(view)) {
        super.bind(view)
        tvTitle.text = title
        linkText?.let {
            link.text = linkText
            link.setOnClickListener {
                root.context.startActivity(
                        WebViewActivity.newIntent(
                                root.context,
                                linkUrl!!,
                                linkText.toString(),
                        )
                )
            }
            link.visibility = View.VISIBLE
        }

        inputFieldWithText.configure(
                text = inputTextTitle,
                hint = hint,
                validator = validator,
                dispatchOnUpdate
        )
    }
}
