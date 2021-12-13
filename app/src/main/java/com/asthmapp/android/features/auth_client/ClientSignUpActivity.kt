package com.asthmapp.android.features.auth_client

import android.os.Bundle
import android.text.style.ForegroundColorSpan
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import com.asthmapp.android.BuildConfig
import com.asthmapp.android.R
import com.asthmapp.android.components.InputField
import com.asthmapp.android.databinding.ActivitySignUpBinding
import com.asthmapp.android.features.auth_client.redux.AuthClientRequests
import com.asthmapp.android.util.linked
import com.asthmapp.features.auth_client.states.AuthState
import com.asthmapp.redux.store

class ClientSignUpActivity : BaseLoginActivity() {

    private val binding by lazy { ActivitySignUpBinding.inflate(layoutInflater) }

    override val btnGoogleSignIn by lazy { binding.btnGoogleSignIn }
    override val btnFacebookSignIn by lazy { binding.btnFacebookSignIn }
    override val parentConstraint by lazy { binding.parentConstraint }
    override val spinner by lazy { binding.spinner }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        initViews()
    }

    private fun initViews() = with(binding) {
        ifEmail.configure(
                type = InputField.Type.EMAIL,
                action = InputField.Action.Next,
                inputHintResId = R.string.enter_your_email
        )
        ifPassword.configure(
                type = InputField.Type.PASSWORD,
                inputHintResId = R.string.enter_your_password
        )
        ifConfirmPassword.configure(
                type = InputField.Type.PASSWORD,
                action = InputField.Action.Go { signUp() },
                inputHintResId = R.string.confirm_password
        )

        btnContinue.configure(
                buttonText = getString(R.string.continue_word),
                backgroundColorId = R.color.royalBlue,
                mainColorId = R.color.white,
                isTextAllCaps = true,
                isTextCentered = true
        ) { signUp() }
        btnGoogleSignIn.configure(
                iconResId = R.drawable.ic_google,
                textResId = R.string.sign_up_with_google,
                textColorId = R.color.ebonyClay,
                backgroundColorId = R.color.white
        )

        btnFacebookSignIn.configure(
                iconResId = R.drawable.ic_facebook,
                textResId = R.string.sign_up_with_facebook,
                textColorId = R.color.white,
                backgroundColorId = R.color.indigo
        )

        tvSignIn.text = getString(R.string.already_have_an_account_sign_in).linked(
                listOf(listOf(ForegroundColorSpan(ContextCompat.getColor(this@ClientSignUpActivity, R.color.colorPrimary))))
        )
        tvSignIn.setOnClickListener { finish() }
        tvVersion.text = applicationContext.getString(R.string.version, BuildConfig.VERSION_NAME)
    }

    private fun signUp() = with(binding) {
        val email = ifEmail.getEnteredText()
        val password = ifPassword.getEnteredText()
        val confirmedPassword = ifConfirmPassword.getEnteredText()
        if (email.isEmpty() || password.isEmpty() || confirmedPassword.isEmpty()) {
            store.dispatch(AuthClientRequests.SignUp.Failure(getString(R.string.fields_can_not_be_empty)))
        } else if (password != confirmedPassword) {
            store.dispatch(AuthClientRequests.SignUp.Failure(getString(R.string.passwords_is_not_match)))
        } else {
            store.dispatch(AuthClientRequests.SignUp(email, password))
        }
    }

    private fun adjustEnabling(enable: Boolean, viewGroup: ViewGroup) {
        for (i in 0 until viewGroup.childCount) {
            val child = viewGroup.getChildAt(i)
            child.isEnabled = enable
            if (child is ViewGroup) {
                adjustEnabling(enable, child)
            }
        }
    }

    private fun render(status: AuthState.Status) = with(binding) {
        when (status) {
            AuthState.Status.IDLE -> {
                adjustEnabling(true, parentConstraint)
                spinner.visibility = View.GONE
            }
            AuthState.Status.PENDING -> {
                adjustEnabling(false, parentConstraint)
                spinner.visibility = View.VISIBLE
            }
            AuthState.Status.SUCCESS -> finish()
        }
    }

    override fun onNewState(state: AuthState) {
        render(state.status)
    }
}
