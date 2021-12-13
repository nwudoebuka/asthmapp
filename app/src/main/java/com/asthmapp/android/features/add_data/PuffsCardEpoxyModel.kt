package com.asthmapp.android.features.add_data

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewPuffsCardBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.features.add_data.redux.AddDataRequests
import com.asthmapp.features.add_data.util.PuffsValidator
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants.INHALER_INFO_LINK

class PuffsCardEpoxyModel : BaseEpoxyModel(R.layout.view_puffs_card) {

    init {
        id("PuffsCardEpoxyModel", hashCode().toString())
    }

    override fun bind(view: View) = with(ViewPuffsCardBinding.bind(view)) {
        super.bind(view)

        counterPrevent.configure(PuffsValidator) {
            store.dispatch(AddDataRequests.UpdatePreventerPuffs(it))
        }

        counterReliever.configure(PuffsValidator) {
            store.dispatch(AddDataRequests.UpdateRelieverPuffs(it))
        }

        counterCombination.configure(PuffsValidator) {
            store.dispatch(AddDataRequests.UpdateCombinationPuffs(it))
        }

        link.setOnClickListener {
            root.context.startActivity(WebViewActivity.newIntent(
                    root.context,
                    INHALER_INFO_LINK,
                    root.context.getString(R.string.how_it_works)
            ))
        }
    }
}