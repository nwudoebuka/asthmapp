package com.asthmapp.android.util

import android.annotation.SuppressLint
import android.content.Context
import com.asthmapp.android.AsthmApplication
import com.asthmapp.redux.store
import com.asthmapp.utils.Settings

class Prefs(private val context: Context) : Settings {

    override fun getIsOnboardingShown() = defaultPrefs.run {
        getBoolean(keyIsOnboardingShown, false)
    }

    override fun putIsOnboardingShown() {
        val editor = defaultPrefs.edit()
        editor.putBoolean(keyIsOnboardingShown, true)
        editor.apply()
    }

    override fun getIsSubscribed() = defaultPrefs.run {
        getBoolean(KEY_IS_SUBSCRIBED, false)
    }

    override fun putIsSubscribed(isSubscribed: Boolean) {
        val editor = defaultPrefs.edit()
        editor.putBoolean(KEY_IS_SUBSCRIBED, isSubscribed)
        editor.apply()
    }

    private val defaultPrefs
        get() = context.getSharedPreferences(context.packageName, Context.MODE_PRIVATE)

    companion object {
        @SuppressLint("StaticFieldLeak")
        private val prefs: Prefs = Prefs(AsthmApplication.app)

        private const val KEY_IS_SUBSCRIBED = "key_is_subscribed"
        private val keyIsOnboardingShown
            get() = "${store.state.auth.user?.id} key_is_onboarding_shown"

        fun get() = prefs
    }
}
