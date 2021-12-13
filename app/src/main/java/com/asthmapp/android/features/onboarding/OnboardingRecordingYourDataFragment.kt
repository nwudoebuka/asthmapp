package com.asthmapp.android.features.onboarding

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.asthmapp.android.R
import com.asthmapp.android.databinding.FragmentOnboardingRecordingYourDataBinding
import com.asthmapp.android.features.add_data.WebViewActivity
import com.asthmapp.features.users.redux.OnboardingRequests
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants

class OnboardingRecordingYourDataFragment : Fragment() {

    private lateinit var binding: FragmentOnboardingRecordingYourDataBinding

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentOnboardingRecordingYourDataBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)
        ivContinue.setOnClickListener { store.dispatch(OnboardingRequests.Next()) }
        fab.setOnClickListener { store.dispatch(OnboardingRequests.Next()) }

        svLayout.setOnClickListener {
            startActivity(WebViewActivity.newIntent(view.context, Constants.WEBSITE_LINK, getString(R.string.app_name)))
        }
        dotsView.configure(Constants.ONBOARDING_DOTS_TOTAL_AMOUNT, Constants.ONBOARDING_DOTS_TOTAL_AMOUNT)
    }
}