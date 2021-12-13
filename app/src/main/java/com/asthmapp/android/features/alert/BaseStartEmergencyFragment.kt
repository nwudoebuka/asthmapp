package com.asthmapp.android.features.alert

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.fragment.app.Fragment
import com.asthmapp.features.emergency.redux.EmergencyRequests
import com.asthmapp.redux.store
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices

open class BaseStartEmergencyFragment : Fragment() {

    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(requireActivity())
    }

    private fun requestLocationPermission() {
        val permissions = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
        requestPermissions(permissions, REQUEST_GET_LOCATION)
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            REQUEST_GET_LOCATION -> {
                if (grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
                        && grantResults.lastOrNull() == PackageManager.PERMISSION_GRANTED) {
                    startEmergency()
                } else {
                    requestLocationPermission()
                }
            }
        }
    }

    fun startEmergency() {
        try {
            fusedLocationClient.lastLocation.addOnSuccessListener { location ->
                location?.let {
                    store.dispatch(EmergencyRequests.StartEmergency(lat = it.latitude, lng = it.longitude))
                } ?: run {
                    store.dispatch(EmergencyRequests.StartEmergency(lat = null, lng = null))
                }
            }.addOnFailureListener {
                store.dispatch(EmergencyRequests.StartEmergency(lat = null, lng = null))
            }
        } catch (e: SecurityException) {
            requestLocationPermission()
        }
    }

    companion object {

        private const val REQUEST_GET_LOCATION = 1
    }
}
