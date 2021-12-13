package com.asthmapp.redux

import com.asthmapp.redux.middlewares.appMiddleware
import com.asthmapp.redux.middlewares.messageMiddleware
import com.asthmapp.redux.reducers.appReducer
import com.asthmapp.redux.states.AppState
import tw.geothings.rekotlin.Store

val store by lazy {
    Store(
            reducer = ::appReducer,
            state = AppState(),
            middleware = listOf(appMiddleware, messageMiddleware)
    )
}
