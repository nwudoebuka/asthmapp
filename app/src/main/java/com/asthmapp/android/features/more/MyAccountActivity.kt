package com.asthmapp.android.features.more

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityMyAccountBinding
import com.asthmapp.android.features.add_data.WebViewActivity
import com.asthmapp.android.features.auth_client.redux.AuthClientRequests
import com.asthmapp.android.util.load
import com.asthmapp.features.auth_client.requests.IAuthRequests
import com.asthmapp.features.auth_client.states.AuthState
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants.PRIVACY_POLICY_LINK
import com.asthmapp.utils.Constants.TERMS_AND_CONDITIONS_LINK
import tw.geothings.rekotlin.StoreSubscriber

class MyAccountActivity : AppCompatActivity(), StoreSubscriber<AuthState> {

    private val binding by lazy { ActivityMyAccountBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        initViews()
    }

    private fun initViews() = with(binding) {
        ivBack.setOnClickListener {
            setResult(RESULT_OK)
            finish()
        }

        btnPrivacyPolicy.configure(
                buttonText = getString(R.string.privacy_policy),
                iconId = R.drawable.ic_lock_with_circle
        ) {
            startActivity(
                    WebViewActivity.newIntent(
                            this@MyAccountActivity,
                            PRIVACY_POLICY_LINK,
                            getString(R.string.terms_and_conditions)
                    )
            )
        }
        btnTermsAndConditions.configure(
                buttonText = getString(R.string.terms_and_conditions),
                iconId = R.drawable.ic_doc
        ) {
            startActivity(
                    WebViewActivity.newIntent(
                            this@MyAccountActivity,
                            TERMS_AND_CONDITIONS_LINK,
                            getString(R.string.terms_and_conditions)
                    )
            )
        }

        btnMySubscriptions.configure(
                getString(R.string.my_subscriptions),
                iconId = R.drawable.ic_gift
        ) {
            val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/account/subscriptions"))
            startActivity(browserIntent)
        }

        btnDeleteAccount.configure(
                buttonText = getString(R.string.delete_account),
                iconId = R.drawable.ic_trash_can,
                mainColorId = R.color.coralRed,
                endImageId = null
        )

        btnLogout.configure(
                buttonText = getString(R.string.log_out),
                mainColorId = R.color.coralRed,
                textSize = 14
        ) { showLogout() }
    }

    private fun showLogout() {
        AlertDialog.Builder(this)
                .setTitle(getString(R.string.log_out))
                .setMessage(getString(R.string.do_you_want_to_log_out))
                .setCancelable(false)
                .setPositiveButton(getString(R.string.stay_logged_in), null)
                .setNegativeButton(getString(R.string.log_out)) { _, _ ->
                    setResult(RESULT_CANCELED)
                    finish()
                }
                .create()
                .show()
    }

    override fun onBackPressed() {
        setResult(RESULT_OK)
        super.onBackPressed()
    }

    private fun showEmailSentDialog() {
        AlertDialog.Builder(this).apply {
            setTitle(R.string.verify_email)
            setMessage(R.string.please_check_your_email_inbox)
            setCancelable(true)
            setPositiveButton(getString(android.R.string.ok)) { dialog, _ -> dialog.cancel() }
        }.create().show()
    }

    override fun onNewState(state: AuthState) = with(binding) {
        if (state.user == null) return

        if (state.verifyStatus == AuthState.Status.SUCCESS) {
            showEmailSentDialog()
        }

        state.user?.name?.let {
            tvName.visibility = View.VISIBLE
            tvName.text = it
        } ?: run { tvName.visibility = View.GONE }

        state.user?.photoUrl?.let {
            ivProfile.load(it)
        }

        btnMail.configure(
                buttonText = state.user?.email.orEmpty(),
                isTextBold = (state.user?.isEmailVerified != true),
                iconId = R.drawable.ic_letter,
                endImageId = if (state.user?.isEmailVerified == true) null else R.drawable.ic_warning
        ) {
            if (state.verifyStatus == AuthState.Status.IDLE && state.user?.isEmailVerified != true) {
                store.dispatch(AuthClientRequests.VerifyEmail())
            }
        }
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.auth == newState.auth
            }.select { it.auth }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
        store.dispatch(IAuthRequests.DestroyVerifyEmail())
    }
}
