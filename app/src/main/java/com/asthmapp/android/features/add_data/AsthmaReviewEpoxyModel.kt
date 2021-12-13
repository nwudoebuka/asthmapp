package com.asthmapp.android.features.add_data

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ViewAsthmaReviewCardBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.features.add_data.redux.AddDataRequests
import com.asthmapp.redux.store
import java.text.SimpleDateFormat
import java.util.*

data class AsthmaReviewEpoxyModel(val isReminderActivated: Boolean) : BaseEpoxyModel(R.layout.view_asthma_review_card) {

    init {
        id("AsthmaReviewEpoxyModel", hashCode().toString())
    }

    private var timestamp: Long? = null

    override fun bind(view: View) = with(ViewAsthmaReviewCardBinding.bind(view)) {
        super.bind(view)

        switchReminder.isChecked = isReminderActivated
        switchReminder.setOnCheckedChangeListener { _, isChecked ->
            store.dispatch(AddDataRequests.UpdateIsReminderActivated(isChecked))
        }
        tvSubtitle.setOnClickListener {
            pickDate(this)
        }
    }

    private fun pickDate(binding: ViewAsthmaReviewCardBinding) {
        val calendar = Calendar.getInstance()

        DatePickerDialog(binding.root.context, { _, year, monthOfYear, dayOfMonth ->
            TimePickerDialog(binding.root.context, { _, hour, minute ->
                val currentCalendar = Calendar.getInstance()
                currentCalendar[Calendar.YEAR] = year
                currentCalendar[Calendar.MONTH] = monthOfYear
                currentCalendar[Calendar.DAY_OF_MONTH] = dayOfMonth
                currentCalendar[Calendar.HOUR_OF_DAY] = hour
                currentCalendar[Calendar.MINUTE] = minute

                timestamp = currentCalendar.timeInMillis

                store.dispatch(AddDataRequests.UpdateScheduledReminder(currentCalendar.timeInMillis))
                binding.tvDate.text = SimpleDateFormat("yyyy-MM-dd HH:mm").format(timestamp)
            }, calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), true).show()
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH)).show()
    }
}