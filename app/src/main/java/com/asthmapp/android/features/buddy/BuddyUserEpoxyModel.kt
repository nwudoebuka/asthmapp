package com.asthmapp.android.features.buddy

import android.content.Context
import android.view.View
import androidx.appcompat.app.AlertDialog
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewBuddyUserItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.features.home.reports.ReportsActivity
import com.asthmapp.features.buddy.BuddyUser
import com.asthmapp.features.buddy.redux.BuddyRequests
import com.asthmapp.redux.store

data class BuddyUserEpoxyModel(
        private val buddyUser: BuddyUser
) : BaseEpoxyModel(R.layout.view_buddy_user_item) {

    init {
        id("BuddyUserEpoxyModel", buddyUser.toString())
    }

    override fun bind(view: View) = with(ViewBuddyUserItemBinding.bind(view)) {
        super.bind(view)
        tvFullName.text = buddyUser.fullName

        ivStatus.setImageResource(
                when (buddyUser.status) {
                    BuddyUser.Status.PENDING -> R.drawable.ic_grey_dot
                    BuddyUser.Status.ACCEPTED -> R.drawable.ic_green_dot
                    BuddyUser.Status.EMERGENCY -> R.drawable.ic_warning
                }
        )

        root.setOnClickListener {
            when (buddyUser.status) {
                BuddyUser.Status.PENDING -> showBuddyAcceptDialog(root.context)
                BuddyUser.Status.ACCEPTED -> root.context.startActivity(ReportsActivity.newIntent(root.context, buddyUser.id))
                BuddyUser.Status.EMERGENCY -> {
                    if (listOf(buddyUser.locationLng, buddyUser.locationLat).all { it != null }) {
                        root.context.startActivity(BuddyEmergencyActivity.newIntent(root.context, buddyUser))
                    } else {
                        showMissingBuddyLocationDialog(root.context)
                    }
                }
            }
        }
    }

    private fun showMissingBuddyLocationDialog(context: Context) = AlertDialog.Builder(context)
            .setTitle(context.getString(R.string.missing_buddy_location))
            .setMessage(context.getString(R.string.missing_buddy_location_explanation))
            .setCancelable(false)
            .setNeutralButton(context.getString(R.string.ok)) { _, _ -> }
            .create()
            .show()

    private fun showBuddyAcceptDialog(context: Context) = AlertDialog.Builder(context)
            .setTitle(context.getString(R.string.buddy_request))
            .setMessage(context.getString(R.string.buddy_request_explanation, buddyUser.fullName))
            .setCancelable(false)
            .setPositiveButton(context.getString(R.string.accept)) { _, _ ->
                store.dispatch(BuddyRequests.AcceptBuddyRequest(buddyUser.id))
            }
            .setNegativeButton(context.getString(R.string.reject)) { _, _ ->
                store.dispatch(BuddyRequests.RejectBuddyRequest(buddyUser.id))
            }
            .create()
            .show()
}