package com.asthmapp.android.features.add_data

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewCardIncidentBinding
import com.asthmapp.android.databinding.ViewCardWithInputFieldItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.features.add_data.util.IValueValidator

data class IncidentCardFieldEpoxyModel(
        private val title: String,
        private val hint: String,
        private val linkText: CharSequence? = null,
        private val date:String,
        private val btnTitle:String,
        private val linkUrl: String? = null,
        private val inputTextTitle: String,
        private val validator: IValueValidator,
        private val dispatchOnUpdate: (text: String) -> Unit
) : BaseEpoxyModel(R.layout.view_card_incident) {

    init {
        id("IncidentCardFieldEpoxyModel", hashCode().toString())
    }

    override fun bind(view: View) = with(ViewCardIncidentBinding.bind(view)) {
        super.bind(view)
        tvTitle.text = title
        incidentDate.text = date
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


addIncidentBtn.setText(
        btnTitle
)

    }
}
