package com.asthmapp.android.features.components

import android.content.Context
import android.graphics.Color
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.databinding.CircleChartWithDescriptionBinding
import com.github.mikephil.charting.animation.Easing
import com.github.mikephil.charting.data.PieData
import com.github.mikephil.charting.data.PieDataSet
import com.github.mikephil.charting.data.PieEntry

class CircleChartWithDescription(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = CircleChartWithDescriptionBinding.inflate(LayoutInflater.from(context), this, true)

    init {
        initChart()
    }

    fun setData(entries: List<Int>) = with(binding) {
        tvPrevent.text = context.getString(R.string.preventer_inhaler_with_percent, entries.getOrNull(0)?.toInt())
        tvReliever.text = context.getString(R.string.reliever_inhaler_with_percent, entries.getOrNull(1)?.toInt())
        tvCombination.text = context.getString(R.string.combination_inhaler_with_percent, entries.getOrNull(2)?.toInt())

        val dataSet = PieDataSet(entries.map { PieEntry(it.toFloat(), "") }, "Election Results").apply {
            setDrawValues(false)
            setDrawIcons(false)
            colors = listOf(
                    ContextCompat.getColor(context, R.color.colorAccent),
                    ContextCompat.getColor(context, R.color.jordyBlue),
                    ContextCompat.getColor(context, R.color.hawkesBlue)
            )
        }

        chart.data = PieData(dataSet)
        chart.invalidate()
    }

    private fun initChart() = with(binding.chart) {
        setUsePercentValues(true)
        description.isEnabled = false
        legend.isEnabled = false

        dragDecelerationFrictionCoef = 0.95f
        isDrawHoleEnabled = true

        setHoleColor(Color.WHITE)

        holeRadius = 85f

        rotationAngle = 0f
        isRotationEnabled = false
        isHighlightPerTapEnabled = false

        spin(3000, 0f, 360f, Easing.EaseInOutQuad)
    }
}
