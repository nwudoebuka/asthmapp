package com.asthmapp.android.features.auth_client

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ProgressBar
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import com.asthmapp.android.AsthmApplication
import com.asthmapp.android.features.auth_client.redux.AuthClientRequests
import com.asthmapp.android.features.components.SocialButton
import com.asthmapp.features.auth_client.states.AuthState
import com.asthmapp.redux.store
import com.facebook.CallbackManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginManager
import com.facebook.login.LoginResult
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.common.api.ApiException
import com.google.firebase.auth.FacebookAuthProvider
import com.google.firebase.auth.GoogleAuthProvider
import tw.geothings.rekotlin.StoreSubscriber

abstract class BaseLoginActivity : AppCompatActivity(), StoreSubscriber<AuthState> {

    private lateinit var facebookCallbackManager: CallbackManager
    abstract val btnGoogleSignIn: SocialButton
    abstract val btnFacebookSignIn: SocialButton
    abstract val parentConstraint: ConstraintLayout
    abstract val spinner: ProgressBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN)

        initializeFacebookSignIn()
    }

    override fun onStart() {
        super.onStart()

        btnGoogleSignIn.addOnClickListener { signInWithGoogle() }
        btnFacebookSignIn.addOnClickListener { signInWithFacebook() }

        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.auth.status == newState.auth.status
            }.select { it.auth }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    private fun render(status: AuthState.Status) {
        when (status) {
            AuthState.Status.IDLE -> {
                adjustControls(true, parentConstraint)
                spinner.visibility = View.GONE
            }
            AuthState.Status.PENDING -> {
                adjustControls(false, parentConstraint)
                spinner.visibility = View.VISIBLE
            }
            AuthState.Status.SUCCESS -> {
                setResult(Activity.RESULT_OK)
                finish()
            }
        }
    }

    private fun adjustControls(enable: Boolean, viewGroup: ViewGroup) {
        for (i in 0 until viewGroup.childCount) {
            val child = viewGroup.getChildAt(i)
            child.isEnabled = enable
            if (child is ViewGroup) {
                adjustControls(enable, child)
            }
        }
    }

    override fun onNewState(state: AuthState) {
        render(state.status)
    }

    private fun initializeFacebookSignIn() {
        facebookCallbackManager = CallbackManager.Factory.create()
        LoginManager.getInstance().registerCallback(
                facebookCallbackManager,
                object : FacebookCallback<LoginResult?> {
                    override fun onSuccess(loginResult: LoginResult?) {
                        loginResult?.let {
                            store.dispatch(AuthClientRequests.SignIn.WithCredential(FacebookAuthProvider.getCredential(it.accessToken.token)))
                        }
                    }

                    override fun onCancel() {}
                    override fun onError(exception: FacebookException) {
                        exception.printStackTrace()
                    }
                }
        )
    }

    private fun signInWithFacebook() {
        LoginManager.getInstance().logInWithReadPermissions(this, listOf("email", "public_profile"))
    }

    private fun signInWithGoogle() {
        val signInIntent = AsthmApplication.app.googleSignInClient.signInIntent
        startActivityForResult(signInIntent, REQUEST_GOOGLE_SIGN_IN)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_GOOGLE_SIGN_IN) {
            try {
                val task = GoogleSignIn.getSignedInAccountFromIntent(data)
                val account = task.getResult(ApiException::class.java)
                account?.let {
                    store.dispatch(AuthClientRequests.SignIn.WithCredential(GoogleAuthProvider.getCredential(account.idToken, null)))
                }
            } catch (exception: ApiException) {
                exception.printStackTrace()
            }
        }

        facebookCallbackManager.onActivityResult(requestCode, resultCode, data)
    }

    companion object {
        const val REQUEST_GOOGLE_SIGN_IN = 1
    }
}
