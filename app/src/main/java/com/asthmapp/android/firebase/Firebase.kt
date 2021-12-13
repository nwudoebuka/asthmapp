package com.asthmapp.android.firebase

import com.asthmapp.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser

object Firebase {
    val auth = FirebaseAuth.getInstance()

    fun fetchUser(callback: (User?) -> Unit) {
        val firebaseUser = auth.currentUser ?: run {
            callback(null)
            return@fetchUser
        }
        firebaseUser.getIdToken(false).addOnCompleteListener { task ->
            callback(task.result?.token?.let { token ->
                firebaseUser.toUser(token)
            })
        }
    }

    private fun FirebaseUser.toUser(token: String) = User(
            id = uid,
            name = displayName,
            email = email,
            isEmailVerified = isEmailVerified,
            photoUrl = photoUrl?.toString(),
            token = token,
            phoneNumber = phoneNumber
    )
}
