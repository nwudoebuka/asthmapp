package com.asthmapp.android.features.home

import android.content.res.Resources
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Rect
import android.view.View
import androidx.annotation.ColorInt
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.RecyclerView.ItemDecoration

class DotsIndicatorDecoration(
        private val radius: Int,
        private val indicatorItemPadding: Int,
        private val indicatorHeight: Int,
        @ColorInt colorInactive: Int,
        @ColorInt colorActive: Int
) : ItemDecoration() {
    private val inactivePaint: Paint = Paint()
    private val activePaint: Paint = Paint()

    init {
        val strokeWidth: Float = Resources.getSystem().displayMetrics.density * 1

        inactivePaint.run {
            strokeCap = Paint.Cap.ROUND
            this.strokeWidth = strokeWidth
            style = Paint.Style.STROKE
            isAntiAlias = true
            color = colorInactive
        }
        activePaint.run {
            strokeCap = Paint.Cap.ROUND
            this.strokeWidth = strokeWidth
            style = Paint.Style.FILL
            isAntiAlias = true
            color = colorActive
        }
    }

    override fun onDraw(c: Canvas, parent: RecyclerView, state: RecyclerView.State) {
        super.onDraw(c, parent, state)
        val adapter = parent.adapter ?: return
        val itemCount = adapter.itemCount
        if (itemCount <= 1) return

        // center horizontally, calculate width and subtract half from center
        val totalLength = (radius * 2 * itemCount).toFloat()
        val paddingBetweenItems = (0.coerceAtLeast(itemCount - 1) * indicatorItemPadding).toFloat()
        val indicatorTotalWidth = totalLength + paddingBetweenItems
        val indicatorStartX = (parent.width - indicatorTotalWidth) / 2f

        // center vertically in the allotted space
        val indicatorPosY = parent.height - indicatorHeight.toFloat() / 2f
        drawInactiveDots(c, indicatorStartX, indicatorPosY, itemCount)
        val activePosition = when (parent.layoutManager) {
            is GridLayoutManager -> {
                (parent.layoutManager as GridLayoutManager?)?.findFirstVisibleItemPosition()
            }
            is LinearLayoutManager -> {
                (parent.layoutManager as LinearLayoutManager?)?.findFirstVisibleItemPosition()
            }
            else -> {
                // not supported layout manager
                return
            }
        }
        if (activePosition == RecyclerView.NO_POSITION || activePosition == null) {
            return
        }

        // find offset of active page if the user is scrolling
        parent.layoutManager?.findViewByPosition(activePosition) ?: return

        drawActiveDot(c, indicatorStartX, indicatorPosY, activePosition)
    }

    private fun drawInactiveDots(c: Canvas, indicatorStartX: Float, indicatorPosY: Float, itemCount: Int) {
        // width of item indicator including padding
        val itemWidth = (radius * 2 + indicatorItemPadding).toFloat()
        var start = indicatorStartX + radius
        for (i in 0 until itemCount) {
            c.drawCircle(start, indicatorPosY, radius.toFloat(), inactivePaint)
            start += itemWidth
        }
    }

    private fun drawActiveDot(c: Canvas, indicatorStartX: Float, indicatorPosY: Float, highlightPosition: Int) {
        // width of item indicator including padding
        val itemWidth = (radius * 2 + indicatorItemPadding).toFloat()
        val highlightStart = indicatorStartX + radius + itemWidth * highlightPosition
        c.drawCircle(highlightStart, indicatorPosY, radius.toFloat(), activePaint)
    }

    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        super.getItemOffsets(outRect, view, parent, state)
        val itemCount = parent.adapter?.itemCount ?: return
        if (itemCount <= 1) return

        outRect.bottom = indicatorHeight
    }
}