package com.asthmapp.android.features.auth_buddy

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.asthmapp.android.R
import com.asthmapp.android.components.InputField
import com.asthmapp.android.databinding.ActivityBuddySignInBinding
import com.asthmapp.android.features.auth_buddy.redux.AuthBuddyRequests
import com.asthmapp.features.auth_buddy.states.AuthBuddyState
import com.asthmapp.redux.store
import tw.geothings.rekotlin.StoreSubscriber

class BuddySignInActivity : AppCompatActivity(), StoreSubscriber<AuthBuddyState> {

    private val binding by lazy { ActivityBuddySignInBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        initViews()
    }

    private fun initViews() = with(binding) {
        ifPhone.configure(
                type = InputField.Type.TEXT,
                action = InputField.Action.Go {
                    signInWithPhoneNumber()
                },
                inputHintResId = R.string.enter_your_phone_number
        )

        btnContinue.configure(
                buttonText = getString(R.string.continue_word),
                backgroundColorId = R.color.royalBlue,
                mainColorId = R.color.white,
                isTextAllCaps = true,
                isTextCentered = true
        ) {
            signInWithPhoneNumber()
        }

        spinner.root.visibility = View.VISIBLE
    }

    private fun signInWithPhoneNumber() {
        val phoneNumber = binding.ifPhone.getEnteredText()
        store.dispatch(AuthBuddyRequests.GetVerificationCode(this, phoneNumber))
    }

    override fun onNewState(state: AuthBuddyState) {
        var isSpinnerVisible = 0

        when (state.getVerificationCodeStatus) {
            AuthBuddyState.Status.PENDING -> isSpinnerVisible = isSpinnerVisible or 1
            AuthBuddyState.Status.IDLE -> isSpinnerVisible = isSpinnerVisible or 0
            AuthBuddyState.Status.SUCCESS -> {
                startActivity(VerifyCodeActivity.newIntent(this, binding.ifPhone.getEnteredText()))
            }
        }

        when (state.signInStatus) {
            AuthBuddyState.Status.PENDING -> isSpinnerVisible = isSpinnerVisible or 1
            AuthBuddyState.Status.IDLE -> isSpinnerVisible = isSpinnerVisible or 0
            AuthBuddyState.Status.SUCCESS -> {
                setResult(RESULT_OK)
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
}

