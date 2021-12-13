package com.asthmapp.android.features.onboarding

import android.app.DatePickerDialog
import android.os.Bundle
import android.text.InputType
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.asthmapp.android.R
import com.asthmapp.android.databinding.FragmentBasicInformationBinding
import com.asthmapp.features.users.models.Gender
import com.asthmapp.features.users.models.UserUpdateData
import com.asthmapp.features.users.redux.OnboardingRequests
import com.asthmapp.features.users.redux.OnboardingState
import com.asthmapp.redux.store
import tw.geothings.rekotlin.StoreSubscriber
import java.util.*
import kotlin.math.roundToInt

class BasicInformationFragment : Fragment(), StoreSubscriber<OnboardingState> {

    private lateinit var binding: FragmentBasicInformationBinding

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentBasicInformationBinding.inflate(inflater, container, false)
        return binding.root
    }

    private var isMetricDimension = true
    private var timestamp: Long? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)

        tvMetric.setOnClickListener {
            isMetricDimension = false
            metricLayout.visibility = View.GONE
            imperialLayout.visibility = View.VISIBLE
        }

        tvImperial.setOnClickListener {
            isMetricDimension = true
            metricLayout.visibility = View.VISIBLE
            imperialLayout.visibility = View.GONE
        }

        dotsView.configure(7, 1)

        etBirthDate.inputType = InputType.TYPE_NULL
        etBirthDate.setOnClickListener {
            pickDate()
        }

        fab.setOnClickListener {
            val birthDate = getBirthdateFromUser()
            val fullName = etName.text.toString()
            val height = getHeightFromUser()
            val gender = getGenderFromUser()

            if (birthDate == null || fullName.isBlank() || height == null || gender == null) {
                Toast.makeText(requireContext(), getString(R.string.some_fields_are_empty_or_wrong), Toast.LENGTH_SHORT).show()
            } else {
                store.dispatch(
                        OnboardingRequests.UpdateData(
                                UserUpdateData(
                                        fullName = etName.text.toString(),
                                        birthdate = birthDate,
                                        height = height,
                                        gender = gender
                                )
                        )
                )
            }
        }
    }

    private fun pickDate() {
        val calendar = Calendar.getInstance()

        val picker = DatePickerDialog(requireContext(), { _, year, monthOfYear, dayOfMonth ->
            val currentCalendar = Calendar.getInstance()
            currentCalendar[Calendar.YEAR] = year
            currentCalendar[Calendar.MONTH] = monthOfYear
            currentCalendar[Calendar.DAY_OF_MONTH] = dayOfMonth
            timestamp = currentCalendar.timeInMillis

            binding.etBirthDate.setText(dayOfMonth.toString() + "/" + (monthOfYear + 1) + "/" + year)
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH))
        picker.show()
    }

    private fun getBirthdateFromUser(): Long? {
        return timestamp
    }

    private fun getHeightFromUser(): Int? = with(binding) {
        return if (isMetricDimension) {
            etCentimeter.text.toString().toIntOrNull()
        } else {
            val foots = etFoots.text.toString().toIntOrNull()
            val inches = etInches.text.toString().toIntOrNull()

            if (foots == null || inches == null) return null

            return footsToCentimeter(foots) + inchesToCentimeter(inches)
        }
    }

    private fun footsToCentimeter(foots: Int): Int {
        return (foots * 30.48).roundToInt()
    }

    private fun inchesToCentimeter(inches: Int): Int {
        return (inches * 2.54).roundToInt()
    }

    private fun getGenderFromUser() = when {
        binding.rbFemale.isChecked -> Gender.FEMALE
        binding.rbMale.isChecked -> Gender.MALE
        binding.rbUnspecified.isChecked -> Gender.UNSPECIFIED
        else -> null
    }

    override fun onNewState(state: OnboardingState) {
        when (state.submitDataStatus) {
            OnboardingState.Status.IDLE -> {
                binding.spinner.root.visibility = View.GONE
            }
            OnboardingState.Status.PENDING -> {
                binding.spinner.root.visibility = View.VISIBLE
            }
            OnboardingState.Status.SUCCESS -> {
                store.dispatch(OnboardingRequests.Next())
            }
        }
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.onboarding.submitDataStatus == newState.onboarding.submitDataStatus
            }.select { it.onboarding }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }
}