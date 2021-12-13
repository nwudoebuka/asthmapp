package com.asthmapp.android.features.alert

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.databinding.BuddyItemBinding
import com.asthmapp.android.databinding.ViewBuddiesAlertItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.features.home.BuddyItem
import com.asthmapp.android.features.home.toBuddyItems
import com.asthmapp.features.emergency.AlertStatus
import com.asthmapp.features.home.entity.Buddy
import com.asthmapp.redux.store

class BuddiesAlertEpoxyModel(
        private val alertStatus: AlertStatus,
        private val showBuddies: Boolean,
        private val number: Int,
        private val text: String
) : BaseEpoxyModel(R.layout.view_buddies_alert_item) {

    init {
        id("BuddiesAlertEpoxyModel $alertStatus $number $text $showBuddies")
    }

    override fun bind(view: View) = with(ViewBuddiesAlertItemBinding.bind(view)) {
        super.bind(view)

        clearBuddies(this)

        if (showBuddies) {
            rootOptionsLayout.visibility = View.VISIBLE
            store.state.home.buddies
                    .filter { it.status == Buddy.Status.ACCEPTED }
                    .toBuddyItems(root.context).forEach { buddy ->
                        val option = createOption(buddy, root.context)

                        rootOptionsLayout.addView(option)
                        flowOptions.addView(option)
                    }
        } else {
            rootOptionsLayout.visibility = View.GONE
        }

        tvNumber.text = number.toString()
        tvTitle.text = text

        when (alertStatus) {
            AlertStatus.PAST -> {
                animationView.visibility = View.GONE
                tvNumber.setBackgroundResource(R.drawable.circle_black_background)
                materialCard.strokeColor = ContextCompat.getColor(root.context, R.color.darkturquoise)
                tvTitle.alpha = 1f
            }
            AlertStatus.ACTIVE -> {
                animationView.visibility = View.VISIBLE
                tvNumber.setBackgroundResource(0)
                materialCard.strokeColor = ContextCompat.getColor(root.context, R.color.indigo)
                tvTitle.alpha = 1f
            }
            AlertStatus.FUTURE -> {
                animationView.visibility = View.GONE
                tvNumber.setBackgroundResource(R.drawable.circle_black_background)
                materialCard.strokeColor = ContextCompat.getColor(root.context, R.color.brightBlack)
                tvTitle.alpha = 0.5f
            }
        }
    }

    private fun clearBuddies(binding: ViewBuddiesAlertItemBinding) = with(binding) {
        (0 until rootOptionsLayout.childCount).map { rootOptionsLayout.getChildAt(it) }.forEach {
            if (it != flowOptions) rootOptionsLayout.removeView(it)
        }
        flowOptions.referencedIds = IntArray(0)
    }

    private fun createOption(
            buddy: BuddyItem,
            context: Context
    ) = BuddyItemBinding.inflate(LayoutInflater.from(context), null, false).apply {
        item.text = buddy.name
        item.setBackgroundColor(ContextCompat.getColor(context, R.color.ebonyClay))
        item.setTextColor(ContextCompat.getColor(context, R.color.white))
        item.icon = buddy.icon
        item.id = View.generateViewId()
    }.root
}
