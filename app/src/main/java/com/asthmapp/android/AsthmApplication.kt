package com.asthmapp.android

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import androidx.appcompat.app.AppCompatDelegate
import com.asthmapp.android.components.AndroidMessageHandler
import com.asthmapp.android.features.subscription.SubscriptionRequests
import com.asthmapp.android.firebase.Firebase
import com.asthmapp.android.util.Prefs
import com.asthmapp.features.auth_buddy.requests.IAuthBuddyRequests
import com.asthmapp.features.auth_client.requests.IAuthRequests
import com.asthmapp.redux.middlewares.fetchSubscriptionsRequestProvider
import com.asthmapp.redux.middlewares.messageHandlers
import com.asthmapp.redux.middlewares.pushToken
import com.asthmapp.redux.store
import com.asthmapp.utils.settings
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.firebase.messaging.FirebaseMessaging

class AsthmApplication : Application() {

    lateinit var googleSignInClient: GoogleSignInClient

    override fun onCreate() {
        super.onCreate()

        app = this
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
        registerActivityLifecycleCallbacks(activeActivityCallbacks)

        messageHandlers.add(AndroidMessageHandler())

        initializeGoogleSignIn()
        initNotificationToken()
        initFetchSubscriptionsRequest()

        fetchUser()
        initSettings()
    }

    private fun initializeGoogleSignIn() {
        val googleSignInOptions = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestIdToken(DEFAULT_WEB_CLIENT_ID)
                .requestEmail()
                .build()

        googleSignInClient = GoogleSignIn.getClient(this, googleSignInOptions)
    }

    private fun initNotificationToken() {
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                pushToken = task.result
            }
        }
    }

    private fun fetchUser() {
        Firebase.fetchUser {
            if (it?.phoneNumber.isNullOrBlank()) store.dispatch(IAuthRequests.FetchUser(it))
            else store.dispatch(IAuthBuddyRequests.FetchUser(it))
        }
    }

    private fun initSettings() {
        settings = Prefs.get()
    }

    private fun initFetchSubscriptionsRequest() {
        fetchSubscriptionsRequestProvider = { SubscriptionRequests.FetchSubscriptions() }
    }

    private val activeActivityCallbacks = ActiveActivityLifecycleCallbacks()

    override fun onTerminate() {
        unregisterActivityLifecycleCallbacks(activeActivityCallbacks)
        super.onTerminate()
    }

    fun getActiveActivity(): Activity? = activeActivityCallbacks.getActiveActivity()

    companion object {

        const val DEFAULT_WEB_CLIENT_ID = "166542197002-nf3n54bk5u51d0us3qeijdvs3iale44c.apps.googleusercontent.com"

        lateinit var app: AsthmApplication
    }
}

class ActiveActivityLifecycleCallbacks : Application.ActivityLifecycleCallbacks {

    private var activeActivity: Activity? = null

    fun getActiveActivity(): Activity? = activeActivity

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
    }

    override fun onActivityStarted(activity: Activity) {
        activeActivity = activity
    }

    override fun onActivityResumed(activity: Activity) {
    }

    override fun onActivityPaused(activity: Activity) {
    }

    override fun onActivityStopped(activity: Activity) {
        activeActivity = null
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
    }

    override fun onActivityDestroyed(activity: Activity) {

    }
}

val appContext: Context
    get() = AsthmApplication.app
