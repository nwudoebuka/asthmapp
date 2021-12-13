package com.asthmapp.android.features.onboarding

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.asthmapp.android.databinding.FragmentOnboardingEndBinding
import com.asthmapp.features.users.redux.OnboardingRequests
import com.asthmapp.redux.store

class OnboardingEndFragment : Fragment() {

    private lateinit var binding: FragmentOnboardingEndBinding

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentOnboardingEndBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.ivDone.setOnClickListener { store.dispatch(OnboardingRequests.Next()) }
    }
}