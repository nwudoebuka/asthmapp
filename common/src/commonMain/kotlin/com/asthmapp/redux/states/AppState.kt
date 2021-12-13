package com.asthmapp.redux.states

import com.asthmapp.features.add_data.redux.AddDataState
import com.asthmapp.features.auth_buddy.states.AuthBuddyState
import com.asthmapp.features.auth_client.states.AuthState
import com.asthmapp.features.buddy.redux.BuddyState
import com.asthmapp.features.emergency.redux.EmergencyState
import com.asthmapp.features.home.redux.HomeState
import com.asthmapp.features.learn.redux.LearnState
import com.asthmapp.features.notifications.redux.NotificationsState
import com.asthmapp.features.reports.redux.ReportsState
import com.asthmapp.features.subscription.redux.SubscriptionState
import com.asthmapp.features.users.redux.OnboardingState
import tw.geothings.rekotlin.StateType

data class AppState(
        val auth: AuthState = AuthState(),
        val authBuddy: AuthBuddyState = AuthBuddyState(),
        val notifications: NotificationsState = NotificationsState(),
        val learn: LearnState = LearnState(),
        val addData: AddDataState = AddDataState(),
        val home: HomeState = HomeState(),
        val reports: ReportsState = ReportsState(),
        val emergency: EmergencyState = EmergencyState(),
        val buddy: BuddyState = BuddyState(),
        val onboarding: OnboardingState = OnboardingState(),
        val subscription: SubscriptionState = SubscriptionState()
) : StateType
