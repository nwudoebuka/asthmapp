package com.asthmapp.android.features.add_data

import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityAddDataBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.features.add_data.redux.AddDataRequests
import com.asthmapp.features.add_data.redux.AddDataState
import com.asthmapp.features.add_data.util.IValueValidator
import com.asthmapp.features.add_data.util.PeakExpiratoryFlowValidator
import com.asthmapp.features.add_data.util.PulseValidator
import com.asthmapp.features.add_data.util.Sp02Validator
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants.PEAK_EXPIRATORY_FLOW_INFO_LINK
import com.asthmapp.utils.Constants.PULSE_INFO_LINK
import com.asthmapp.utils.Constants.SP02_INFO_LINK
import tw.geothings.rekotlin.StoreSubscriber

class AddDataActivity : AppCompatActivity(), StoreSubscriber<AddDataState> {

    private val epoxyController by lazy { EpoxyController(this) }
    private val binding by lazy { ActivityAddDataBinding.inflate(layoutInflater) }

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

    override fun onBackPressed() {
        super.onBackPressed()
        overridePendingTransition(R.anim.nothing, R.anim.bottom_down)
    }

    private fun initViews() = with(binding) {
        recyclerView.adapter = epoxyController.adapter
        recyclerView.layoutManager = LinearLayoutManager(this@AddDataActivity)
        epoxyController.requestModelBuild()
        btnSubmit.setOnClickListener {
            store.dispatch(AddDataRequests.SubmitData())
        }
    }

    private class EpoxyController(
            private val context: Context
    ) : BaseEpoxyController<Unit>() {

        override fun buildModels() {
            CardWithInputFieldEpoxyModel(
                    title = context.getString(R.string.blood_oxygen_level),
                    hint = context.getString(R.string.xx),
                    linkText = context.getText(R.string.expected_values),
                    linkUrl = SP02_INFO_LINK,
                    inputTextTitle = "%",
                    validator = Sp02Validator,
            ) {
                store.dispatch(AddDataRequests.UpdateBloodOxygenLevel(it))
            }.addTo(this)

            CardWithInputFieldEpoxyModel(
                    title = context.getString(R.string.pulse),
                    hint = context.getString(R.string.xx),
                    linkText = context.getText(R.string.expected_values),
                    linkUrl = PULSE_INFO_LINK,
                    inputTextTitle = context.getString(R.string.bpm),
                    validator = PulseValidator
            ) {
                store.dispatch(AddDataRequests.UpdatePulse(it))
            }.addTo(this)

            PuffsCardEpoxyModel().addTo(this)

            CardWithInputFieldEpoxyModel(
                    title = context.getString(R.string.peak_expiratory_flow),
                    hint = context.getString(R.string.xxx),
                    linkText = context.getText(R.string.expected_values),
                    linkUrl = PEAK_EXPIRATORY_FLOW_INFO_LINK,
                    inputTextTitle = context.getString(R.string.lpm),
                    validator = PeakExpiratoryFlowValidator
            ) {
                store.dispatch(AddDataRequests.UpdatePeakExpiratoryFlow(it))
            }.addTo(this)

            IncidentCardFieldEpoxyModel(
           title = context.getString(R.string.incidents),
            hint = "",
            linkText = context.getString(R.string.whats_incidence),
            date = context.getString(R.string.today),
            btnTitle = context.getString(R.string.add),
            linkUrl = "",
            inputTextTitle = "",
           validator = PulseValidator,
            ){
                //store.dispatch(AddDataRequests.UpdatePulse(it))
            }.addTo(this)

            AsthmaReviewEpoxyModel(store.state.home.isReminderActivated).addTo(this)
        }
    }

    override fun onNewState(state: AddDataState) = with(binding) {
        when (state.status) {
            AddDataState.Status.PENDING -> {
                spinner.root.visibility = View.VISIBLE
            }
            AddDataState.Status.SUBMITTED -> {
                spinner.root.visibility = View.GONE
                store.dispatch(AddDataRequests.Destroy)
                finish()
            }
            AddDataState.Status.IDLE -> {
                spinner.root.visibility = View.GONE
            }
        }
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.addData == newState.addData
            }.select { it.addData }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }
}
