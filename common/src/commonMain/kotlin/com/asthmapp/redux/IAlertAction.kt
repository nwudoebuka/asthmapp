package com.asthmapp.redux

import tw.geothings.rekotlin.Action

interface IAlertAction : Action {

    val message: String?
}
