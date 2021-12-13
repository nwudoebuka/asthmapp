package com.asthmapp.android.features.auth_buddy

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.CountDownTimer
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.components.InputField
import com.asthmapp.android.databinding.ActivityVerifyCodeBinding
import com.asthmapp.android.features.auth_buddy.redux.AuthBuddyRequests
import com.asthmapp.features.auth_buddy.states.AuthBuddyState
import com.asthmapp.redux.store
import tw.geothings.rekotlin.StoreSubscriber

class VerifyCodeActivity : AppCompatActivity(), StoreSubscriber<AuthBuddyState> {

    private val phoneNumber: String
        get() = intent.getStringExtra(PHONE_NUMBER).orEmpty()

    private val binding by lazy { ActivityVerifyCodeBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        initViews()

        startTimeCounter()
        binding.tvResend.disable()
    }

    private fun startTimeCounter() {
        object : CountDownTimer(300000, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                binding.tvWatch.text = "${millisUntilFinished.minutes()}:${millisUntilFinished.seconds()}"
            }

            override fun onFinish() {
                binding.tvResend.enable()
            }
        }.start()
    }

    private fun Long.minutes(): String {
        val minutes = this / 60000L
        return if (minutes < 10) {
            "0$minutes"
        } else {
            minutes.toString()
        }
    }

    private fun Long.seconds(): String {
        val seconds = (this % 60000L) / 1000L
        return if (seconds < 10) {
            "0$seconds"
        } else {
            seconds.toString()
        }
    }

    private fun TextView.enable() {
        isEnabled = true
        setTextColor(ContextCompat.getColor(this@VerifyCodeActivity, R.color.colorPrimary))
    }

    private fun TextView.disable() {
        isEnabled = false
        setTextColor(ContextCompat.getColor(this@VerifyCodeActivity, R.color.slateGray))
    }

    private fun initViews() = with(binding) {
        tvSubtitle.text = getString(R.string.please_enter_the_verification_code, phoneNumber.takeLast(2))
        ifCode.configure(
                type = InputField.Type.TEXT,
                action = InputField.Action.Go { verifyCode() },
                inputHintResId = R.string.enter_verification_code
        )

        btnVerify.configure(
                buttonText = getString(R.string.verify),
                backgroundColorId = R.color.royalBlue,
                mainColorId = R.color.white,
                isTextAllCaps = true,
                isTextCentered = true
        ) { verifyCode() }

        tvResend.setOnClickListener {
            store.dispatch(AuthBuddyRequests.GetVerificationCode(this@VerifyCodeActivity, phoneNumber))
            tvResend.disable()
            startTimeCounter()
        }
    }

    private fun verifyCode() {
        val code = binding.ifCode.getEnteredText()
        store.dispatch(AuthBuddyRequests.VerifyCode(code))
    }

    override fun onNewState(state: AuthBuddyState) {
        var isSpinnerVisible = 0

        isSpinnerVisible = isSpinnerVisible or when (state.getVerificationCodeStatus) {
            AuthBuddyState.Status.PENDING -> 1
            AuthBuddyState.Status.IDLE -> 0
            AuthBuddyState.Status.SUCCESS -> 0
        }

        when (state.signInStatus) {
            AuthBuddyState.Status.PENDING -> isSpinnerVisible = isSpinnerVisible or 1
            AuthBuddyState.Status.IDLE -> isSpinnerVisible = isSpinnerVisible or 0
            AuthBuddyState.Status.SUCCESS -> {
                isSpinnerVisible = isSpinnerVisible or 0
                finish()
            }
        }

        binding.spinner.root.visibility = if (isSpinnerVisible == 1) View.VISIBLE else View.GONE
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.authBuddy == newState.authBuddy
            }.select { it.authBuddy }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    companion object {
        private const val PHONE_NUMBER = "phone_number"

        fun newIntent(
                context: Context,
                phoneNumber: String
        ) = Intent(context, VerifyCodeActivity::class.java).apply {
            putExtra(PHONE_NUMBER, phoneNumber)
        }
    }
}

