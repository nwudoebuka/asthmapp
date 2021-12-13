package com.asthmapp.redux.reducers

import com.asthmapp.features.add_data.redux.addDataReducer
import com.asthmapp.features.auth_buddy.reducers.authBuddyReducer
import com.asthmapp.features.auth_client.reducers.authReducer
import com.asthmapp.features.buddy.redux.buddyReducer
import com.asthmapp.features.emergency.redux.emergencyReducer
import com.asthmapp.features.home.redux.homeReducer
import com.asthmapp.features.learn.redux.learnReducer
import com.asthmapp.features.notifications.redux.notificationsReducer
import com.asthmapp.features.reports.redux.reportsReducer
import com.asthmapp.features.subscription.redux.subscriptionReducer
import com.asthmapp.features.users.redux.onboardingReducer
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Action

fun appReducer(action: Action, state: AppState?): AppState {
    requireNotNull(state)
    return AppState(
            auth = authReducer(action, state),
            authBuddy = authBuddyReducer(action, state),
            notifications = notificationsReducer(action, state),
            learn = learnReducer(action, state),
            addData = addDataReducer(action, state),
            home = homeReducer(action, state),
            reports = reportsReducer(action, state),
            emergency = emergencyReducer(action, state),
            buddy = buddyReducer(action, state),
            onboarding = onboardingReducer(action, state),
            subscription = subscriptionReducer(action, state)
    )
}
