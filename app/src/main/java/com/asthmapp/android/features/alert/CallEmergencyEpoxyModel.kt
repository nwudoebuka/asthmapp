package com.asthmapp.android.features.alert

import android.content.Intent
import android.net.Uri
import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewCallEmergencyAlertItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel

class CallEmergencyEpoxyModel : BaseEpoxyModel(R.layout.view_call_emergency_alert_item) {

    init {
        id("CallEmergencyEpoxyModel")
    }

    override fun bind(view: View) = with(ViewCallEmergencyAlertItemBinding.bind(view)) {
        super.bind(view)

        root.setOnClickListener {
            root.context.startActivity(Intent(Intent.ACTION_DIAL).apply { data = Uri.parse("tel:999") })
        }
    }
}
