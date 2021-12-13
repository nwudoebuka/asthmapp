package com.asthmapp.android.features.home

import android.content.Context
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Base64
import androidx.annotation.ColorRes
import androidx.appcompat.content.res.AppCompatResources
import com.asthmapp.android.R
import com.asthmapp.android.features.components.convertDpToPixel
import com.asthmapp.features.home.entity.Buddy

fun List<Buddy>.toBuddyItems(context: Context) = map {
    BuddyItem(
            name = it.fullName,
            icon = it.drawable(context),
            borderColor = when (it.status) {
                Buddy.Status.PENDING -> R.color.silver
                Buddy.Status.ACCEPTED -> R.color.royalBlue
                Buddy.Status.REJECTED -> R.color.coralRed
            }
    )
}

private fun Buddy.drawable(context: Context) = avatar?.let { image ->
    val byteArray = Base64.decode(image, Base64.DEFAULT)
    val bitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
    val bitmapSize = convertDpToPixel(24f, context).toInt()
    BitmapDrawable(context.resources, circleBitmap(Bitmap.createScaledBitmap(bitmap, bitmapSize, bitmapSize, false)))
} ?: AppCompatResources.getDrawable(context, R.drawable.ic_profile)

private fun circleBitmap(bitmap: Bitmap): Bitmap? {
    val rounder = Bitmap.createBitmap(bitmap.width, bitmap.height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(rounder)

    val xferPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    xferPaint.color = Color.RED
    canvas.drawRoundRect(RectF(0f, 0f, bitmap.width.toFloat(), bitmap.height.toFloat()), bitmap.width / 2f, bitmap.height / 2f, xferPaint)
    xferPaint.xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_IN)

    val result = Bitmap.createBitmap(bitmap.width, bitmap.height, Bitmap.Config.ARGB_8888)

    Canvas(result).apply {
        drawBitmap(bitmap, 0f, 0f, null)
        drawBitmap(rounder, 0f, 0f, xferPaint)
    }

    return result
}

data class BuddyItem(val name: String, val icon: Drawable?, @ColorRes val borderColor: Int)
