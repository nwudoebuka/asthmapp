package com.asthmapp.android.features.onboarding

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityContainerBinding
import com.asthmapp.features.users.redux.OnboardingState
import com.asthmapp.redux.store
import com.asthmapp.utils.settings
import tw.geothings.rekotlin.StoreSubscriber

class OnboardingActivity : AppCompatActivity(), StoreSubscriber<OnboardingState> {

    private val binding by lazy { ActivityContainerBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
    }

    override fun onNewState(state: OnboardingState) {
        when (state.progress) {
            is OnboardingState.Progress.Start -> {
                OnboardingStartFragment()
            }
            is OnboardingState.Progress.BasicInformation -> {
                BasicInformationFragment()
            }
            is OnboardingState.Progress.HomePage -> {
                OnboardingTitleDescriptionFragment.newInstance(
                        OnboardingTitleDescriptionFragment.Data(
                                backgroundResourceId = R.drawable.ic_home_page_onboarding,
                                titleId = R.string.home_page,
                                descriptionId = R.string.home_page_onboarding_description,
                                passedAmount = 2
                        )
                )
            }
            is OnboardingState.Progress.Learn -> {
                OnboardingTitleDescriptionFragment.newInstance(
                        OnboardingTitleDescriptionFragment.Data(
                                backgroundResourceId = R.drawable.ic_learn_onboarding,
                                titleId = R.string.learn,
                                descriptionId = R.string.learn_onboarding_description,
                                passedAmount = 3
                        )
                )
            }
            is OnboardingState.Progress.Buddy -> {
                OnboardingTitleDescriptionFragment.newInstance(
                        OnboardingTitleDescriptionFragment.Data(
                                backgroundResourceId = R.drawable.ic_buddy_onboarding,
                                titleId = R.string.buddy,
                                descriptionId = R.string.buddy_onboarding_description,
                                passedAmount = 4
                        )
                )
            }
            is OnboardingState.Progress.Report -> {
                OnboardingTitleDescriptionFragment.newInstance(
                        OnboardingTitleDescriptionFragment.Data(
                                backgroundResourceId = R.drawable.ic_report_onboarding,
                                titleId = R.string.report,
                                descriptionId = R.string.report_onboarding_description,
                                passedAmount = 5
                        )
                )
            }
            is OnboardingState.Progress.Notification -> {
                OnboardingTitleDescriptionFragment.newInstance(
                        OnboardingTitleDescriptionFragment.Data(
                                backgroundResourceId = R.drawable.ic_notification_onboarding,
                                titleId = R.string.notification,
                                descriptionId = R.string.notification_onboarding_description,
                                passedAmount = 6
                        )
                )
            }
            is OnboardingState.Progress.Recording -> {
                OnboardingRecordingYourDataFragment()
            }
            is OnboardingState.Progress.End -> {
                OnboardingEndFragment()
            }
            is OnboardingState.Progress.Finished -> {
                settings.putIsOnboardingShown()
                finish()
                null
            }
        }?.let {
            replaceFragment(it)
        }
    }

    override fun onBackPressed() {
        return
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.onboarding.progress == newState.onboarding.progress
            }.select { it.onboarding }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    private fun AppCompatActivity.replaceFragment(fragment: Fragment) {
        supportFragmentManager
                .beginTransaction()
                .replace(R.id.fragment_container, fragment)
                .commitAllowingStateLoss()
    }
}