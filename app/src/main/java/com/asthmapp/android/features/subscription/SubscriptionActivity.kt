package com.asthmapp.android.features.subscription

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import com.asthmapp.android.databinding.ActivitySubscriptionBinding
import com.asthmapp.features.subscription.ISubscriptionRequests
import com.asthmapp.features.subscription.Sku
import com.asthmapp.features.subscription.redux.SubscriptionState
import com.asthmapp.redux.store
import tw.geothings.rekotlin.StoreSubscriber

class SubscriptionActivity : AppCompatActivity(), StoreSubscriber<SubscriptionState> {

    companion object {

        fun newIntent(context: Context) = Intent(context, SubscriptionActivity::class.java)
    }

    private val binding by lazy { ActivitySubscriptionBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        initViews()

        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.subscription == newState.subscription
            }.select { it.subscription }
        }

        store.dispatch(SubscriptionRequests.FetchSkuDetails())
    }

    override fun onDestroy() {
        super.onDestroy()
        store.unsubscribe(this)
    }

    private fun initViews() {
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN)

        binding.ivBack.setOnClickListener { finish() }
    }

    override fun onNewState(state: SubscriptionState) = when (state.status) {
        SubscriptionState.Status.IDLE -> updateViews(state.monthlySku)
        SubscriptionState.Status.PENDING -> showLoading()
        SubscriptionState.Status.SUBSCRIBED -> setResult(RESULT_OK).also { finish() }
        SubscriptionState.Status.FAILED -> store.dispatch(ISubscriptionRequests.Reset).also { finish() }
    }

    private fun updateViews(monthlySku: Sku?) = if (monthlySku == null) {
        showLoading()
    } else {
        showContent(monthlySku)
    }

    private fun showContent(monthlySku: Sku) {
        showMonthlySubscription(monthlySku)
    }

    private fun showLoading() {
        hideMonthlySubscription()
    }

    private fun hideMonthlySubscription() = with(binding) {
        monthlyProgress.visibility = View.VISIBLE
        monthlyContent.visibility = View.INVISIBLE
        btnContinue.setOnClickListener { }
    }

    private fun showMonthlySubscription(monthlySku: Sku) = with(binding) {
        monthlyProgress.visibility = View.INVISIBLE
        monthlyContent.visibility = View.VISIBLE
        tvAmount.text = monthlySku.monthlyPriceString
        tvCurrency.text = monthlySku.currency

        btnContinue.setOnClickListener { launchBillingFlow(monthlySku) }
    }

    private fun launchBillingFlow(sku: Sku) {
        store.dispatch(SubscriptionRequests.LaunchBillingFlow(this, sku))
    }
}
