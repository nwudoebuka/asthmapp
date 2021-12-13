package com.asthmapp.android.features.home.reports

import android.view.View
import com.asthmapp.android.R
import com.asthmapp.android.appContext
import com.asthmapp.android.databinding.TitleSubtitleImageLayoutBinding
import com.asthmapp.android.databinding.ViewReportItemBinding
import com.asthmapp.android.epoxy.BaseEpoxyModel
import com.asthmapp.android.util.DateFormats
import com.asthmapp.features.home.entity.Indicator
import com.asthmapp.features.reports.Period
import com.asthmapp.features.reports.ReportItem
import com.asthmapp.features.reports.redux.ReportsRequests
import com.asthmapp.redux.store

data class ReportEpoxyModel(
        private val reportItem: ReportItem,
        private val isShareEnabled: Boolean
) : BaseEpoxyModel(R.layout.view_report_item) {

    init {
        id("ReportEpoxyModel", reportItem.toString())
    }

    override fun bind(view: View) = with(ViewReportItemBinding.bind(view)) {
        super.bind(view)

        tvTitle.text = when (reportItem.period.type) {
            Period.Type.DAY -> DateFormats.dayFormat.format(reportItem.period.startInMillis)
            Period.Type.MONTH -> DateFormats.monthFormat.format(reportItem.period.startInMillis)
            Period.Type.WEEK -> DateFormats.formatWeekFromMillis(reportItem.period.startInMillis, " ", true)
            else -> throw IllegalStateException()
        }

        btnShare.visibility = if (isShareEnabled) View.VISIBLE else View.INVISIBLE
        btnShare.setOnClickListener {
            store.dispatch(ReportsRequests.GetReportCSV(reportItem.period))
        }

        bindSp02(sp02)
        bindPulse(pulse)
        bindPef(pef)
        bindAttacks(attacks)
    }

    private fun bindSp02(sp02: TitleSubtitleImageLayoutBinding) = bind(
            view = sp02,
            title = appContext.getString(R.string.avg_blood_oxygen_level_percent, reportItem.averageSp02.value),
            level = reportItem.averageSp02.level
    )

    private fun bindPulse(pulse: TitleSubtitleImageLayoutBinding) = bind(
            view = pulse,
            title = appContext.getString(R.string.avg_pulse_beats_in_min, reportItem.averagePulse.value),
            level = reportItem.averagePulse.level
    )

    private fun bindPef(pef: TitleSubtitleImageLayoutBinding) = bind(
            view = pef,
            title = appContext.getString(R.string.avg_pef_in_min, reportItem.averagePef.value),
            level = reportItem.averagePef.level
    )

    private fun bindAttacks(attacks: TitleSubtitleImageLayoutBinding) = bind(
            view = attacks,
            title = appContext.getString(R.string.total_attacks_number, reportItem.attacks.value),
            level = reportItem.attacks.level
    )

    private fun bind(view: TitleSubtitleImageLayoutBinding, title: String, level: Indicator.Level) {
        view.tvTitle.text = title
        when (level) {
            Indicator.Level.NORMAL -> {
                view.tvSubtitle.text = view.root.context.getString(R.string.normal_for_your_condition)
                view.image.setImageResource(R.drawable.ic_like)
            }
            Indicator.Level.ALERT -> {
                view.tvSubtitle.text = view.root.context.getText(R.string.lower_than_your_average_learn_more)
                view.image.setImageResource(R.drawable.ic_alert)
            }
        }
    }
}
