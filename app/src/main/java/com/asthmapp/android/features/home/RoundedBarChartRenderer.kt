package com.asthmapp.android.features.home

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Path
import android.graphics.RectF
import com.github.mikephil.charting.animation.ChartAnimator
import com.github.mikephil.charting.interfaces.dataprovider.BarDataProvider
import com.github.mikephil.charting.interfaces.datasets.IBarDataSet
import com.github.mikephil.charting.renderer.BarChartRenderer
import com.github.mikephil.charting.utils.Utils
import com.github.mikephil.charting.utils.ViewPortHandler
import kotlin.math.ceil
import kotlin.math.roundToInt

// Adapted from com.github.mikephil.charting.renderer.BarChartRenderer

class RoundedBarChartRenderer(
        chart: BarDataProvider,
        animator: ChartAnimator,
        viewPortHandler: ViewPortHandler,
        private val radiusPx: Float,
        private val color: Int
) : BarChartRenderer(chart, animator, viewPortHandler) {

    private val mBarShadowRectBuffer = RectF()

    override fun drawDataSet(canvas: Canvas, dataSet: IBarDataSet, index: Int) {
        val trans = mChart.getTransformer(dataSet.axisDependency)
        mBarBorderPaint.color = dataSet.barBorderColor
        mBarBorderPaint.strokeWidth = Utils.convertDpToPixel(dataSet.barBorderWidth)
        val drawBorder = dataSet.barBorderWidth > 0f
        val phaseX = mAnimator.phaseX
        val phaseY = mAnimator.phaseY

        // draw the bar shadow before the values
        if (mChart.isDrawBarShadowEnabled) {
            mShadowPaint.color = dataSet.barShadowColor
            val barData = mChart.barData
            val barWidth = barData.barWidth
            val barWidthHalf = barWidth / 2.0f
            var x: Float
            var i = 0
            val count = ceil(dataSet.entryCount.toFloat() * phaseX.toDouble()).toInt().coerceAtMost(dataSet.entryCount)
            while (i < count) {
                val e = dataSet.getEntryForIndex(i)
                x = e.x
                mBarShadowRectBuffer.left = x - barWidthHalf
                mBarShadowRectBuffer.right = x + barWidthHalf
                trans.rectValueToPixel(mBarShadowRectBuffer)
                if (!mViewPortHandler.isInBoundsLeft(mBarShadowRectBuffer.right)) {
                    i++
                    continue
                }
                if (!mViewPortHandler.isInBoundsRight(mBarShadowRectBuffer.left)) break
                mBarShadowRectBuffer.top = mViewPortHandler.contentTop()
                mBarShadowRectBuffer.bottom = mViewPortHandler.contentBottom()
                canvas.drawRoundRect(mBarShadowRectBuffer, radiusPx, radiusPx, mShadowPaint)
                i++
            }
        }

        // initialize the buffer
        val buffer = mBarBuffers[index]
        buffer.setPhases(phaseX, phaseY)
        buffer.setDataSet(index)
        buffer.setInverted(mChart.isInverted(dataSet.axisDependency))
        buffer.setBarWidth(0.4f)
        buffer.feed(dataSet)
        trans.pointValuesToPixel(buffer.buffer)

        val chunkedBuffer = buffer.buffer.toList().chunked(4)

        val maxValue = chunkedBuffer.map { innerBuffer ->
            RectF(innerBuffer[0], innerBuffer[1], innerBuffer[2], innerBuffer[3]).height()
        }.max()

        for (chunkIndex in chunkedBuffer.indices) {
            val innerBuffer = chunkedBuffer[chunkIndex]
            if (!mViewPortHandler.isInBoundsLeft(innerBuffer[2])) continue
            if (!mViewPortHandler.isInBoundsRight(innerBuffer[0])) break

            val rectF = RectF(innerBuffer[0], innerBuffer[1], innerBuffer[2], innerBuffer[3])
            maxValue?.let {
                mRenderPaint.color = setAlphaForColor(rectF.height() / maxValue)
            }

            val barPath = buildBarPath(rectF)
            canvas.drawPath(barPath, mRenderPaint)
            if (drawBorder) {
                canvas.drawPath(barPath, mBarBorderPaint)
            }
        }
    }

    private fun setAlphaForColor(percent: Float): Int {
        val a = Color.alpha(color)
        val r = (Color.red(color) / percent).roundToInt()
        val g = (Color.green(color) / percent).roundToInt()
        val b = (Color.blue(color) / (percent)).roundToInt()
        return Color.argb(
                a,
                r.coerceAtMost(220).coerceAtLeast(1),
                g.coerceAtMost(220).coerceAtLeast(1),
                b.coerceAtMost(220).coerceAtLeast(1)
        )
    }

    private fun buildBarPath(bounds: RectF): Path {
        val width = bounds.width()
        val height = bounds.height()
        val r = radiusPx
                .coerceAtMost(width / 2)
                .coerceAtMost(height / 2)

        val path = Path()

        path.moveTo(bounds.left, bounds.bottom - r)
        path.rLineTo(0f, -(height - 2 * r))
        path.rQuadTo(0f, -r, +r, -r)

        path.rLineTo(+(width - r * 2), 0f)
        path.rQuadTo(+r, 0f, +r, +r)

        path.rLineTo(0f, +(height - 2 * r))
        path.rQuadTo(0f, +r, -r, +r)

        path.rLineTo(-(width - r * 2), 0f)
        path.rQuadTo(-r, 0f, -r, -r)

        path.close()
        return path
    }
}
