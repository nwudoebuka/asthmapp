package com.asthmapp.redux

import tw.geothings.rekotlin.Action

interface IToastAction : Action {

    val message: String?
}
