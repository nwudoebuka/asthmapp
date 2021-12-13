package com.asthmapp.android.shared

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewEmergencyItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel

data class EmergencyEpoxyModel(
        private val onTap: () -> Unit
) : BaseEpoxyModel(R.layout.view_emergency_item) {

    init {
        id("EmergencyEpoxyModel")
    }

    override fun bind(view: View) = with(ViewEmergencyItemBinding.bind(view)) {
        super.bind(view)

        btnEmergency.configure(
                buttonText = view.context.getString(R.string.emergency),
                mainColorId = R.color.coralRed,
                textSize = 16
        ) {
            onTap()
        }
    }
}
