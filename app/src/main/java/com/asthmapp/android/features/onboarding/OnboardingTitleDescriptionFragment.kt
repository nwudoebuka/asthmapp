package com.asthmapp.android.features.onboarding

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.asthmapp.android.databinding.FragmentTitleDescriptionBinding
import com.asthmapp.android.util.onboardingTitleDescriptionFragmentData
import com.asthmapp.features.users.redux.OnboardingRequests
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants.ONBOARDING_DOTS_TOTAL_AMOUNT
import java.io.Serializable

class OnboardingTitleDescriptionFragment : Fragment() {

    private lateinit var binding: FragmentTitleDescriptionBinding

    private val data: Data
        get() = arguments?.onboardingTitleDescriptionFragmentData as? Data
                ?: throw IllegalStateException()

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentTitleDescriptionBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)

        ivBackground.setImageResource(data.backgroundResourceId)
        tvTitle.setText(data.titleId)
        tvDescription.setText(data.descriptionId)
        dotsView.configure(ONBOARDING_DOTS_TOTAL_AMOUNT, data.passedAmount)
        fab.setOnClickListener { store.dispatch(OnboardingRequests.Next()) }
        tvSkip.setOnClickListener { store.dispatch(OnboardingRequests.Next.Finish) }
    }

    data class Data(
            val backgroundResourceId: Int,
            val titleId: Int,
            val descriptionId: Int,
            val passedAmount: Int
    ) : Serializable

    companion object {

        fun newInstance(data: Data) = OnboardingTitleDescriptionFragment().apply {
            arguments = Bundle().apply {
                this.onboardingTitleDescriptionFragmentData = data
            }
        }
    }
}