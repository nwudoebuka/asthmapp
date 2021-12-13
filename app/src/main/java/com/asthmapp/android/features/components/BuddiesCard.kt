package com.asthmapp.android.features.components

import android.content.Context
import android.content.res.ColorStateList
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import com.asthmapp.android.databinding.BuddiesCardBinding
import com.asthmapp.android.databinding.BuddyItemBinding
import com.asthmapp.android.features.home.BuddyItem
import com.asthmapp.utils.Constants.MAX_AMOUNT_OF_BUDDIES

class BuddiesCard(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = BuddiesCardBinding.inflate(LayoutInflater.from(context), this, true)

    fun configure(
            buddyItems: List<BuddyItem>,
            onBuddyTap: (Int) -> Unit,
            addNewOnClickListener: () -> Unit,
    ) = with(binding) {
        clearFlows()

        buddyItems.forEachIndexed { index, buddy ->
            val option = createOption(buddy).apply {
                setOnClickListener {
                    onBuddyTap(index)
                }
            }
            addViewToChainLayout(option)
        }

        tvAddNew.isEnabled = buddyItems.size < MAX_AMOUNT_OF_BUDDIES
        tvAddNew.alpha = if (buddyItems.size < MAX_AMOUNT_OF_BUDDIES) 1f else 0.5f

        tvAddNew.setOnClickListener { addNewOnClickListener() }
    }

    private fun clearFlows() = with(binding) {
        (0 until rootOptionsLayout.childCount).map { rootOptionsLayout.getChildAt(it) }.forEach {
            if (it != flowOptions) rootOptionsLayout.removeView(it)
        }
        flowOptions.referencedIds = IntArray(0)
    }

    private fun addViewToChainLayout(view: View) = with(binding) {
        rootOptionsLayout.addView(view)
        flowOptions.addView(view)
    }


    private fun createOption(
            buddy: BuddyItem,
    ) = BuddyItemBinding.inflate(LayoutInflater.from(context), null, false).apply {
        item.text = buddy.name
        item.icon = buddy.icon
        item.strokeColor = ColorStateList.valueOf(context.resources.getColor(buddy.borderColor))
        item.id = View.generateViewId()
    }.root
}
