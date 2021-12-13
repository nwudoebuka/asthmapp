package com.asthmapp.android.features.learn.epoxyModels

import android.text.Editable
import android.text.TextWatcher
import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewSearchItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel

class SearchEpoxyModel(callback: (String) -> Unit) : BaseEpoxyModel(R.layout.view_search_item) {

    init {
        id("SearchEpoxyModel")
    }

    override fun bind(view: View) = with(ViewSearchItemBinding.bind(view)) {
        super.bind(view)
        editText.addTextChangedListener(textEditorWatcher)
    }

    private val textEditorWatcher = object : TextWatcher {
        override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
        override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {}

        override fun afterTextChanged(s: Editable) {
            callback(s.toString())
        }
    }
}