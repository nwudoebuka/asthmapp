package com.asthmapp.features.emergency

fun getAlertStatusFromEmergencyStageNumber(number: Int, status: Emergency.Status) =
        when (status) {
            Emergency.Status.SMS_TO_BUDDIES -> {
                when (number) {
                    1 -> AlertStatus.ACTIVE
                    else -> AlertStatus.FUTURE
                }
            }
            Emergency.Status.AWAITING_CALLS -> {
                when (number) {
                    1 -> AlertStatus.PAST
                    2 -> AlertStatus.ACTIVE
                    else -> AlertStatus.FUTURE
                }
            }
            Emergency.Status.CALLING_EMERGENCY -> {
                when (number) {
                    in 1..2 -> AlertStatus.PAST
                    3 -> AlertStatus.ACTIVE
                    else -> AlertStatus.FUTURE
                }
            }
            Emergency.Status.CANCELLED -> AlertStatus.PAST
        }

enum class AlertStatus { PAST, ACTIVE, FUTURE }
