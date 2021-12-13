package com.asthmapp.features.add_data.util

object PuffsValidator : IValueValidator {

    override fun isValid(value: String) = value.toIntOrNull() != null && value.toInt() in MIN_BOUND..MAX_BOUND

    private const val MIN_BOUND = 0
    private const val MAX_BOUND = 100
}