package com.asthmapp.android.util

import android.os.Bundle
import java.io.Serializable

var Bundle.onboardingTitleDescriptionFragmentData: Serializable?
    get() = getSerializable("topic_id")
    set(value) {
        if (value != null) {
            putSerializable("topic_id", value)
        }
    }
