package com.asthmapp.android.features

import android.animation.Animator
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivitySplashBinding
import com.asthmapp.android.features.auth_buddy.BuddySignInActivity
import com.asthmapp.android.features.auth_client.ClientSignInActivity
import com.asthmapp.android.features.buddy.BuddyActivity
import com.asthmapp.redux.store

class SplashActivity : AppCompatActivity() {

    private val binding by lazy { ActivitySplashBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        initViews()
    }

    private fun initViews() = with(binding) {
        animationView.addAnimatorListener(animatorListener)

        btnLoginAsUser.configure(
                buttonText = getString(R.string.main_user),
                backgroundColorId = R.color.colorPrimary,
                mainColorId = R.color.white,
                isTextAllCaps = true,
                isTextCentered = true
        ) {
            startActivityForResult(Intent(this@SplashActivity, ClientSignInActivity::class.java), REQUEST_CLIENT_SIGN_IN)
        }

        btnLoginAsBuddy.configure(
                buttonText = getString(R.string.buddy),
                backgroundColorId = R.color.colorPrimary,
                mainColorId = R.color.white,
                isTextAllCaps = true,
                isTextCentered = true
        ) {
            startActivityForResult(Intent(this@SplashActivity, BuddySignInActivity::class.java), REQUEST_BUDDY_SIGN_IN)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK) {
            when (requestCode) {
                REQUEST_CLIENT_SIGN_IN -> showMainAndFinish()
                REQUEST_BUDDY_SIGN_IN -> showBuddyAndFinish()
            }
        }
    }

    private val animatorListener = object : Animator.AnimatorListener {

        override fun onAnimationRepeat(animation: Animator?) {}

        override fun onAnimationEnd(animation: Animator?) {
            binding.animationView.visibility = View.GONE
            showNextActivity()
        }

        override fun onAnimationCancel(animation: Animator?) {}

        override fun onAnimationStart(animation: Animator?) {}
    }

    private fun showNextActivity() {
        when {
            store.state.auth.user != null -> showMainAndFinish()
            store.state.authBuddy.user != null -> showBuddyAndFinish()
            else -> binding.llChooseRole.visibility = View.VISIBLE
        }
    }

    private fun showMainAndFinish() {
        startActivity(Intent(this, MainActivity::class.java))
        finish()
    }

    private fun showBuddyAndFinish() {
        startActivity(Intent(this, BuddyActivity::class.java))
        finish()
    }

    companion object {
        const val REQUEST_CLIENT_SIGN_IN = 1
        const val REQUEST_BUDDY_SIGN_IN = 2
    }
}
