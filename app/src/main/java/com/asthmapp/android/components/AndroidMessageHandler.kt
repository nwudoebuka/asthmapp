package com.asthmapp.android.components

import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import com.asthmapp.android.AsthmApplication.Companion.app
import com.asthmapp.android.appContext
import com.asthmapp.redux.middlewares.MessageHandler
import com.asthmapp.redux.middlewares.MessageType

class AndroidMessageHandler : MessageHandler {

    override fun handle(message: String?, messageType: MessageType) {
        when (messageType) {
            MessageType.TOAST -> if (message != null) Toast.makeText(appContext, message, Toast.LENGTH_LONG).show()
            MessageType.ALERT -> {
                if (message != null) {
                    app.getActiveActivity()?.let {
                        AlertDialog.Builder(it)
                                .setMessage(message)
                                .setPositiveButton(android.R.string.ok, null)
                                .create()
                                .show()
                    }
                }
            }
        }
    }
}
