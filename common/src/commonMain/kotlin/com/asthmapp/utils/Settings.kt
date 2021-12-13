package com.asthmapp.utils

lateinit var settings: Settings

interface Settings {

    fun getIsOnboardingShown(): Boolean

    fun putIsOnboardingShown()

    fun getIsSubscribed(): Boolean

    fun putIsSubscribed(isSubscribed: Boolean)
}