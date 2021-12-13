package com.asthmapp.features.add_data.util

object PeakExpiratoryFlowValidator : IValueValidator {

    override fun isValid(value: String) = (value.toIntOrNull() != null
                && value.toInt() in MIN_BOUND..MAX_BOUND
                && value.commonPrefixWith("00") != "00"
            ) || value.isEmpty()

    private const val MIN_BOUND = 0
    private const val MAX_BOUND = 1000
}