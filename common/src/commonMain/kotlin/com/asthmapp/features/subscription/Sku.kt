package com.asthmapp.features.subscription

data class Sku(
        val id: String,
        val currency: String,
        val monthlyPrice: Double,
        val details: Any,
) {
    val monthlyPriceString = "${(monthlyPrice * 100).toInt().toDouble() / 100}"
}