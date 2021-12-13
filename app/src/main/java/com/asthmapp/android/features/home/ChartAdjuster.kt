package com.asthmapp.android.features.home

import android.graphics.Canvas
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.features.components.convertDpToPixel
import com.asthmapp.android.util.DateFormats
import com.asthmapp.utils.Constants.AMOUNT_OF_MILLISECONDS_IN_DAY
import com.asthmapp.utils.DateUtils
import com.github.mikephil.charting.charts.BarChart
import com.github.mikephil.charting.components.AxisBase
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.BarData
import com.github.mikephil.charting.data.BarDataSet
import com.github.mikephil.charting.data.BarEntry
import com.github.mikephil.charting.formatter.ValueFormatter
import com.github.mikephil.charting.renderer.XAxisRenderer
import com.github.mikephil.charting.utils.MPPointF
import com.github.mikephil.charting.utils.Transformer
import com.github.mikephil.charting.utils.Utils
import com.github.mikephil.charting.utils.ViewPortHandler

class ChartAdjuster(private val chart: BarChart) {

    init {
        configureChart()
        configureAxisLeft()
        configureXAxis()
        chart.invalidate()
    }

    private val context
        get() = chart.context

    private fun configureChart() = with(chart) {
        description = null
        legend.isEnabled = false
        setXAxisRenderer(CustomXAxisRenderer(viewPortHandler, xAxis, getTransformer(YAxis.AxisDependency.LEFT)))
        extraBottomOffset = 20f
        setTouchEnabled(false)
        axisRight.isEnabled = false
        renderer = RoundedBarChartRenderer(
                this,
                animator,
                viewPortHandler,
                convertDpToPixel(100f, context), ContextCompat.getColor(context, R.color.colorPrimary)
        )
    }

    private fun configureAxisLeft() = with(chart.axisLeft) {
        axisMinimum = 0f
        isEnabled = true
        granularity = 2f
        textColor = ContextCompat.getColor(context, R.color.slateGray)
        gridLineWidth = 0.4f
    }

    private fun configureXAxis() = with(chart.xAxis) {
        isEnabled = true
        labelCount = 4
        yOffset = 10f
        valueFormatter = XAxisValueFormatter()
        textColor = ContextCompat.getColor(context, R.color.slateGray)
        position = XAxis.XAxisPosition.BOTTOM
        setDrawGridLines(false)
    }

    fun updatePoints(points: List<BarEntry>) = with(chart) {
        data = BarData(
                BarDataSet(points, "title").apply {
                    setDrawValues(false)
                }
        )
        invalidate()
    }
}

class CustomXAxisRenderer(viewPortHandler: ViewPortHandler?, xAxis: XAxis?, trans: Transformer?) : XAxisRenderer(viewPortHandler, xAxis, trans) {
    override fun drawLabel(c: Canvas, formattedLabel: String, x: Float, y: Float, anchor: MPPointF, angleDegrees: Float) {
        val line = formattedLabel.split("\n".toRegex()).toTypedArray()
        Utils.drawXAxisValue(c, line[0], x, y, mAxisLabelPaint, anchor, angleDegrees)
        Utils.drawXAxisValue(c, line[1], x, y + mAxisLabelPaint.textSize, mAxisLabelPaint, anchor, angleDegrees);
    }
}

class XAxisValueFormatter : ValueFormatter() {

    override fun getAxisLabel(value: Float, axis: AxisBase?): String {
        val millisOfDay = DateUtils().startOfCurrentWeek() + value.toLong() * 7 * AMOUNT_OF_MILLISECONDS_IN_DAY
        return DateFormats.formatWeekFromMillis(millisOfDay)
    }
}
