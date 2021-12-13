package com.asthmapp.redux.middlewares

import com.asthmapp.redux.IAlertAction
import com.asthmapp.redux.IToastAction
import tw.geothings.rekotlin.Middleware
import tw.geothings.rekotlin.StateType

enum class MessageType { ALERT, TOAST }

interface MessageHandler {

    fun handle(message: String?, messageType: MessageType)
}

val messageHandlers = mutableListOf<MessageHandler>()

val messageMiddleware: Middleware<StateType> = { _, _ ->
    { next ->
        { action ->
            if (action is IToastAction) {
                messageHandlers.forEach { it.handle(action.message, MessageType.TOAST) }
            }
            if (action is IAlertAction) {
                messageHandlers.forEach { it.handle(action.message, MessageType.ALERT) }
            }
            next(action)
        }
    }
}
