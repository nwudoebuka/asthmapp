package com.asthmapp.android.features.buddy

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityMapTravelBinding
import com.asthmapp.features.buddy.BuddyUser
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

class BuddyEmergencyActivity : AppCompatActivity(), OnMapAndViewReadyListener.OnGlobalLayoutAndMapReadyListener {

    private val latitude: Double
        get() = intent.getDoubleExtra(LATITUDE, 0.0)

    private val longitude: Double
        get() = intent.getDoubleExtra(LONGITUDE, 0.0)

    private val fullName: String
        get() = intent.getStringExtra(FULL_NAME).orEmpty()

    private val binding by lazy { ActivityMapTravelBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        val mapFragment = supportFragmentManager.findFragmentById(R.id.mapFragment) as SupportMapFragment

        OnMapAndViewReadyListener(mapFragment, this)

        binding.btnGetDirections.setOnClickListener {
            startActivity(
                    Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse("http://maps.google.com/maps?saddr=&daddr=$latitude,$longitude")
                    )
            )
        }
        initToolbar()
    }

    private fun initToolbar() {
        binding.toolbar.title = getString(R.string.emergency_user, fullName)
        setSupportActionBar(binding.toolbar)
        supportActionBar?.run {
            setDisplayHomeAsUpEnabled(true)
            setDisplayShowHomeEnabled(true)
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressed()
        return true
    }

    override fun onMapReady(googleMap: GoogleMap?) = googleMap?.let { googleMap ->
        googleMap.uiSettings.isMapToolbarEnabled = false
        val placeLatLng = LatLng(latitude, longitude)
        googleMap.addMarker(MarkerOptions().position(placeLatLng)).apply {
            title = getString(R.string.user_is_here, fullName)
        }
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(placeLatLng, 12f))
    } ?: Unit

    companion object {

        private const val FULL_NAME = "full_name"
        private const val LATITUDE = "latitude"
        private const val LONGITUDE = "longitude"

        fun newIntent(
                context: Context,
                buddyUser: BuddyUser
        ) = Intent(context, BuddyEmergencyActivity::class.java).apply {
            putExtra(FULL_NAME, buddyUser.fullName)
            putExtra(LATITUDE, buddyUser.locationLat)
            putExtra(LONGITUDE, buddyUser.locationLng)
        }
    }
}