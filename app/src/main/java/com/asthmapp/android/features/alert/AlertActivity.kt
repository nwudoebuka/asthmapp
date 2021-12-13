package com.asthmapp.android.features.alert

import android.content.Context
import android.os.Bundle
import android.os.CountDownTimer
import android.view.View
import android.widget.EditText
import android.widget.FrameLayout
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityAlertBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.android.features.components.convertDpToPixel
import com.asthmapp.features.emergency.Emergency
import com.asthmapp.features.emergency.getAlertStatusFromEmergencyStageNumber
import com.asthmapp.features.emergency.redux.EmergencyRequests
import com.asthmapp.features.emergency.redux.EmergencyState
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants.EMERGENCY_TIMER_INTERVAL_IN_MILLIS
import tw.geothings.rekotlin.StoreSubscriber
import java.util.*
import kotlin.concurrent.scheduleAtFixedRate

class AlertActivity : AppCompatActivity(), StoreSubscriber<EmergencyState> {

    private val epoxyController by lazy { EpoxyController(context = this) }

    private val binding by lazy { ActivityAlertBinding.inflate(layoutInflater) }

    private lateinit var timer: TimerTask

    override fun onCreate(savedInstanceState: Bundle?): Unit = with(binding) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        window.statusBarColor = ContextCompat.getColor(this@AlertActivity, R.color.black)
        recyclerView.adapter = epoxyController.adapter
        recyclerView.layoutManager = LinearLayoutManager(this@AlertActivity)
        epoxyController.requestModelBuild()

        btnExit.setOnClickListener {
            showCancelEmergencyDialog()
        }
        btnStop.setOnClickListener {
            showCancelEmergencyDialog()
        }

        Timer().scheduleAtFixedRate(EMERGENCY_TIMER_INTERVAL_IN_MILLIS, EMERGENCY_TIMER_INTERVAL_IN_MILLIS) {
            store.dispatch(EmergencyRequests.GetEmergency())
        }

        startTimeCounter()
    }

    override fun onBackPressed() {
        return
    }

    private fun showCancelEmergencyDialog() {
        val code = (1000..9999).random().toString()

        val editText = EditText(this)
        val paddingView = FrameLayout(this).apply {
            val padding = convertDpToPixel(20f, context).toInt()
            setPadding(padding, 0, padding, 0)
            addView(editText)
        }

        val alertDialog = AlertDialog.Builder(this)
                .setTitle(R.string.cancel_emergency)
                .setView(paddingView)
                .setMessage(getString(R.string.emergency_question, code))
                .setPositiveButton(android.R.string.cancel, null)
                .setNegativeButton(R.string.back, null)
                .create()

        alertDialog.show()
        editText.requestFocus()

        alertDialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
            if (editText.text.toString().trim() == code) {
                store.dispatch(EmergencyRequests.CancelEmergency())
                alertDialog.cancel()
            } else {
                editText.error = getString(R.string.code_does_not_match)
                editText.clearFocus()
            }
        }
    }

    class EpoxyController(
            private val context: Context
    ) : BaseEpoxyController<Unit>() {

        var emergency: Emergency? = null
            set(value) {
                field = value
                requestModelBuild()
            }

        override fun buildModels() {
            val status = emergency?.status ?: return

            BuddiesAlertEpoxyModel(getAlertStatusFromEmergencyStageNumber(1, status), true, 1, context.getString(R.string.sending_sms_to_buddies)).addTo(this)
            BuddiesAlertEpoxyModel(getAlertStatusFromEmergencyStageNumber(2, status), false, 2, context.getString(R.string.awaiting_calls_from_buddies_5_min)).addTo(this)
            BuddiesAlertEpoxyModel(getAlertStatusFromEmergencyStageNumber(3, status), false, 3, context.getString(R.string.phone_was_not_picked_up_calling_emergency_services)).addTo(this)
            CallEmergencyEpoxyModel().addIf(status == Emergency.Status.CALLING_EMERGENCY, this)
        }
    }

    override fun onNewState(state: EmergencyState) {
        if (state.emergency == null) {
            finish()
            return
        }

        epoxyController.emergency = state.emergency
    }

    private fun startTimeCounter() {
        object : CountDownTimer(11000, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                binding.tvCount.text = (millisUntilFinished / 1000L).toString()
            }

            override fun onFinish() {
                binding.tvCount.visibility = View.GONE
            }
        }.start()
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.emergency == newState.emergency
            }.select { it.emergency }
        }

        timer = Timer().scheduleAtFixedRate(EMERGENCY_TIMER_INTERVAL_IN_MILLIS, EMERGENCY_TIMER_INTERVAL_IN_MILLIS) {
            runOnUiThread { store.dispatch(EmergencyRequests.GetEmergency()) }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)

        timer.cancel()
    }
}
