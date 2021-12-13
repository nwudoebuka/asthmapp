package com.asthmapp.android.features.notifications.epoxyModels

import android.content.Context
import android.text.Spannable
import android.text.SpannableString
import android.text.TextUtils
import android.text.style.ForegroundColorSpan
import android.view.View
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewNotificationItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.features.notifications.NotificationItem
import com.asthmapp.features.notifications.entity.Notification

data class NotificationEpoxyModel(
        private val notificationItem: NotificationItem,
        private val onLeftButtonTap: () -> Unit
) : BaseEpoxyModel(R.layout.view_notification_item) {

    init {
        id("NotificationEpoxyModel", notificationItem.toString())
    }

    override fun bind(view: View) = with(ViewNotificationItemBinding.bind(view)) {
        super.bind(view)

        val context = view.context

        when (notificationItem.type) {
            Notification.Type.QUESTION -> {
                buttonLeft.text = context.getString(R.string.yes)
                buttonRight.text = context.getString(R.string.no)
            }
            Notification.Type.ADD_DATA -> {
                buttonLeft.text = context.getString(R.string.plus_add_data)
                buttonRight.visibility = View.GONE
            }
            Notification.Type.LEARN_MORE -> {
                buttonLeft.text = context.getString(R.string.learn_more)
                buttonRight.visibility = View.GONE
            }
            Notification.Type.SHOP -> {
                buttonLeft.text = context.getString(R.string.shop)
                buttonRight.visibility = View.GONE
            }
            Notification.Type.INFO -> {
                buttonLeft.visibility = View.GONE
                buttonRight.visibility = View.GONE
            }
        }

        buttonLeft.setOnClickListener {
            onLeftButtonTap()
        }

        tvMessage.text = TextUtils.concat(
                notificationItem.message + " ",
                SpannableString(notificationItem.time).apply {
                    colorString(R.color.slateGray, context)
                }
        )
    }

    override fun unbind(view: View) = with(ViewNotificationItemBinding.bind(view)) {
        super.unbind(view)
        buttonRight.visibility = View.VISIBLE
    }

    private fun SpannableString.colorString(color: Int, context: Context) {
        val foregroundColorSpan = ForegroundColorSpan(ContextCompat.getColor(context, color))
        this.setSpan(foregroundColorSpan, 0, length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
    }
}
