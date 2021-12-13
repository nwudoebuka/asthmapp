package com.asthmapp.android.features.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.PagerSnapHelper
import com.asthmapp.android.R
import com.asthmapp.android.databinding.FragmentHomeBinding
import com.asthmapp.android.databinding.ViewCardWithImageTextBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.android.features.alert.BaseStartEmergencyFragment
import com.asthmapp.android.features.home.reports.ReportsActivity
import com.asthmapp.features.home.entity.Home
import com.asthmapp.features.home.entity.Indicator
import com.asthmapp.features.home.redux.HomeState
import com.asthmapp.redux.store
import com.github.mikephil.charting.data.BarEntry
import tw.geothings.rekotlin.StoreSubscriber

class HomeFragment : BaseStartEmergencyFragment(), StoreSubscriber<HomeState> {

    private lateinit var chartAdjuster: ChartAdjuster
    private val epoxyController = EpoxyController()
    private lateinit var binding: FragmentHomeBinding

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)

        btnReports.setOnClickListener {
            startActivity(ReportsActivity.newIntent(requireContext()))
        }
        btnEmergency.configure(
                buttonText = getString(R.string.emergency),
                mainColorId = R.color.coralRed,
                textSize = 16
        ) {
            startEmergency()
        }

        cvPulse.image.setImageResource(R.drawable.ic_heart)
        cvPulse.tvSubtitle.setText(R.string.avg_pulse_in_the_last_week)

        cvSp02.image.setImageResource(R.drawable.ic_sp02)
        cvSp02.tvSubtitle.setText(R.string.avg_sp02_rate_in_the_last_week)

        cvPef.image.setImageResource(R.drawable.ic_pef)
        cvPef.tvSubtitle.setText(R.string.avg_pef_rate_in_the_last_week)

        chartAdjuster = ChartAdjuster(chart)
        adsRecyclerView.adapter = epoxyController.adapter
        adsRecyclerView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
        PagerSnapHelper().attachToRecyclerView(adsRecyclerView)

        val radius = resources.getDimensionPixelSize(R.dimen.radius)
        val dotsHeight = resources.getDimensionPixelSize(R.dimen.dots_height)
        val color = ContextCompat.getColor(requireContext(), R.color.colorPrimary)

        adsRecyclerView.addItemDecoration(
                DotsIndicatorDecoration(
                        radius = radius,
                        indicatorItemPadding = radius * 4,
                        indicatorHeight = dotsHeight,
                        colorInactive = color,
                        colorActive = color
                )
        )
    }

    private fun generatePoints(puffs: List<Int>) =
            puffs.mapIndexed { index, count ->
                BarEntry(-puffs.size + index + 1f, count.toFloat())
            }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.home == newState.home
            }.select { it.home }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    override fun onNewState(state: HomeState) = with(binding) {
        if (state.ads.isNotEmpty())
            epoxyController.data = state.ads as MutableList<Home.Ad>

        state.alert?.let {
            btnAttention.configure(
                    buttonText = it.title,
                    textSize = 14,
                    iconId = R.drawable.ic_alert,
                    endImageId = null
            )
            btnAttention.visibility = View.VISIBLE
        } ?: run { btnAttention.visibility = View.GONE }

        state.averagePulse?.let {
            configureViewWithStateValue(it.value.toString(), it, cvPulse, "")
        } ?: run { cvPulse.root.visibility = View.GONE }

        state.averageSp02?.let {
            configureViewWithStateValue(it.value.toString(), it, cvSp02, getString(R.string.percent))
        } ?: run { cvSp02.root.visibility = View.GONE }

        state.averagePef?.let {
            configureViewWithStateValue(it.value.toString(), it, cvPef, getString(R.string.lpm))
        } ?: run { cvPef.root.visibility = View.GONE }

        state.stats?.let {
            chartAdjuster.updatePoints(generatePoints(it.weeklyPuffs))
            circleChartWithDescription.setData(
                    listOf(
                            it.preventerInhaler,
                            it.relieverInhaler,
                            it.combinationInhaler,
                    )
            )
            stats.visibility = View.VISIBLE
        } ?: run { stats.visibility = View.GONE }
    }

    private fun configureViewWithStateValue(title: String, indicator: Indicator, view: ViewCardWithImageTextBinding, measureUnit: String) {
        view.tvTitle.text = title
        view.tvMeasureUnit.text = measureUnit
        when (indicator.level) {
            Indicator.Level.NORMAL -> {
                view.ivAlert.visibility = View.GONE
                view.ivLike.visibility = View.VISIBLE
            }
            Indicator.Level.ALERT -> {
                view.ivAlert.visibility = View.VISIBLE
                view.ivLike.visibility = View.GONE
            }
        }
        view.root.visibility = View.VISIBLE
    }

    private class EpoxyController : BaseEpoxyController<Home.Ad>() {

        override fun buildModels() {
            data?.forEach {
                AdEpoxyModel(it).addTo(this)
            }
        }
    }
}
