package com.asthmapp.android.features.auth_client

import android.content.Intent
import android.os.Bundle
import android.text.style.ForegroundColorSpan
import androidx.core.content.ContextCompat
import com.asthmapp.android.BuildConfig
import com.asthmapp.android.R
import com.asthmapp.android.components.InputField
import com.asthmapp.android.databinding.ActivitySignInBinding
import com.asthmapp.android.features.auth_client.redux.AuthClientRequests
import com.asthmapp.android.util.linked
import com.asthmapp.redux.store

class ClientSignInActivity : BaseLoginActivity() {

    private val binding by lazy { ActivitySignInBinding.inflate(layoutInflater) }

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
                action = InputField.Action.Go {
                    signInWithEmailAndPassword()
                },
                inputHintResId = R.string.enter_your_password
        )
        btnSignIn.configure(
                buttonText = getString(R.string.login),
                backgroundColorId = R.color.royalBlue,
                mainColorId = R.color.white,
                isTextAllCaps = true,
                isTextCentered = true
        ) { signInWithEmailAndPassword() }

        btnGoogleSignIn.configure(
                iconResId = R.drawable.ic_google,
                textResId = R.string.sign_in_with_google,
                textColorId = R.color.ebonyClay,
                backgroundColorId = R.color.white
        )

        btnFacebookSignIn.configure(
                iconResId = R.drawable.ic_facebook,
                textResId = R.string.sign_in_with_facebook,
                textColorId = R.color.white,
                backgroundColorId = R.color.indigo
        )

        tvForgotPassword.setOnClickListener { forgotPassword() }
        tvSignUp.text = getString(R.string.new_user_sign_up).linked(
                listOf(listOf(ForegroundColorSpan(ContextCompat.getColor(this@ClientSignInActivity, R.color.colorPrimary))))
        )
        tvSignUp.setOnClickListener {
            startActivity(Intent(this@ClientSignInActivity, ClientSignUpActivity::class.java))
        }
        tvVersion.text = applicationContext.getString(R.string.version, BuildConfig.VERSION_NAME)
    }

    private fun forgotPassword() {
        val email = binding.ifEmail.getEnteredText()
        if (email.isEmpty()) store.dispatch(AuthClientRequests.ForgotPassword.Failure(getString(R.string.forgot_password_empty_email)))
        else store.dispatch(AuthClientRequests.ForgotPassword(email))
    }

    private fun signInWithEmailAndPassword() = with(binding) {
        val email = ifEmail.getEnteredText()
        val password = ifPassword.getEnteredText()
        if (email.isEmpty() || password.isEmpty()) {
            store.dispatch(AuthClientRequests.SignIn.Failure(getString(R.string.fields_can_not_be_empty)))
        } else {
            store.dispatch(AuthClientRequests.SignIn.WithEmailAndPassword(email, password))
        }
    }
}

