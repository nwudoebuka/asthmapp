package com.asthmapp.android.features.home.reports

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewShareButtonBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.features.reports.Period
import com.asthmapp.features.reports.redux.ReportsRequests
import com.asthmapp.redux.store

class ShareButtonEpoxyModel : BaseEpoxyModel(R.layout.view_share_button) {

    init {
        id("ShareButtonEpoxyModel")
    }

    override fun bind(view: View) = with(ViewShareButtonBinding.bind(view)) {
        super.bind(view)
        btnShare.configure(
                buttonText = root.context.getString(R.string.share_full_report),
                iconId = R.drawable.ic_share,
                textSize = 16
        ) {
            store.dispatch(ReportsRequests.GetReportCSV(Period(Period.Type.ALL, 0L)))
        }
    }
}