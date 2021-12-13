package com.asthmapp.android.components

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.asthmapp.android.databinding.CounterViewBinding
import com.asthmapp.features.add_data.util.IValueValidator

class CounterView(context: Context, attrs: AttributeSet) : FrameLayout(context, attrs) {

    private val binding = CounterViewBinding.inflate(LayoutInflater.from(context), this, true)

    private var puffsCount = 0

    fun configure(
            validator: IValueValidator,
            onUpdateListener: (count: Int) -> Unit
    ) = with(binding) {
        plusButton.setOnClickListener {
            if (validator.isValid((puffsCount + 1).toString())) {
                tvCount.text = (++puffsCount).toString()
            }
            onUpdateListener(puffsCount)
        }
        minusButton.setOnClickListener {
            if (validator.isValid((puffsCount - 1).toString())) {
                tvCount.text = (--puffsCount).toString()
            }
            onUpdateListener(puffsCount)
        }
    }
}
