package com.asthmapp.android.features.home.reports

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityReportsBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.features.reports.Period
import com.asthmapp.features.reports.ReportItem
import com.asthmapp.features.reports.redux.ReportsRequests
import com.asthmapp.features.reports.redux.ReportsState
import com.asthmapp.redux.store
import com.asthmapp.utils.DateUtils
import tw.geothings.rekotlin.StoreSubscriber
import java.util.*

class ReportsActivity : AppCompatActivity(), StoreSubscriber<ReportsState> {

    private val epoxyController by lazy { EpoxyController(isShareEnabled = buddyUserId == null) }

    private val buddyUserId: String?
        get() = intent.getStringExtra(BUDDY_USER_ID)

    private val binding by lazy { ActivityReportsBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        initToolbar()
        initViews()
    }

    private fun initToolbar() {
        setSupportActionBar(findViewById(R.id.toolbar))
        supportActionBar?.run {
            setDisplayHomeAsUpEnabled(true)
            setDisplayShowHomeEnabled(true)
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressed()
        return true
    }

    private fun initViews() = with(binding) {
        recyclerView.adapter = epoxyController.adapter
        recyclerView.layoutManager = LinearLayoutManager(this@ReportsActivity)

        segmentedGroup.setOnClickedButtonListener { position ->
            fetchDataAccordingToSelection(position)
        }

        segmentedGroup.position = 0
        fetchDataAccordingToSelection(0)
    }

    private fun fetchDataAccordingToSelection(position: Int) {
        val period = when (position) {
            0 -> Period(Period.Type.DAY, currentDayStartInMillis)
            1 -> Period(Period.Type.WEEK, DateUtils().startOfCurrentWeek())
            2 -> Period(Period.Type.MONTH, firstDayInMonthInMillis)
            else -> throw IllegalStateException()
        }

        store.dispatch(ReportsRequests.FetchReports(period, buddyUserId))
    }

    private val firstDayInMonthInMillis: Long
        get() = Calendar.getInstance(Locale.getDefault()).apply {
            set(Calendar.DAY_OF_MONTH, 1)
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis


    private val currentDayStartInMillis: Long
        get() = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis

    private class EpoxyController(
            private val isShareEnabled: Boolean
    ) : BaseEpoxyController<ReportItem>() {

        override fun buildModels() {
            ShareButtonEpoxyModel().addIf(isShareEnabled, this)
            data?.forEach {
                ReportEpoxyModel(it, isShareEnabled).addTo(this)
            }
        }
    }

    private fun sendReportByEmail(text: String) {
        val intent = Intent(Intent.ACTION_SENDTO).apply {
            data = Uri.parse("mailto:")
            putExtra(Intent.EXTRA_SUBJECT, getString(R.string.asthmapp_report))
            putExtra(Intent.EXTRA_TEXT, text)
        }
        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        }
        store.dispatch(ReportsRequests.DestroyCSV)
    }

    override fun onNewState(state: ReportsState) {
        state.csv?.let {
            sendReportByEmail(it)
        }
if(epoxyController.data?.size != 0 && epoxyController.data?.size != null){
    epoxyController.data = state.reports as MutableList<ReportItem>
}
        when (state.status) {
            ReportsState.Status.IDLE -> {
                binding.spinner.visibility = View.GONE
            }
            ReportsState.Status.PENDING -> {
                binding.spinner.visibility = View.VISIBLE
            }
        }
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.reports == newState.reports
            }.select { it.reports }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        store.dispatch(ReportsRequests.Destroy)
    }

    companion object {
        private const val BUDDY_USER_ID = "buddy_user_id"

        fun newIntent(
                context: Context,
                buddyUserId: String? = null
        ) = Intent(context, ReportsActivity::class.java).apply {
            putExtra(BUDDY_USER_ID, buddyUserId)
        }
    }
}
