package com.asthmapp.android.features.more

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.provider.ContactsContract
import android.util.Base64
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import com.asthmapp.android.R
import com.asthmapp.android.databinding.FragmentMoreBinding
import com.asthmapp.android.features.alert.BaseStartEmergencyFragment
import com.asthmapp.android.features.home.toBuddyItems
import com.asthmapp.features.home.entity.ApiAddBuddy
import com.asthmapp.features.home.entity.Buddy
import com.asthmapp.features.home.redux.HomeRequests
import com.asthmapp.features.home.redux.HomeState
import com.asthmapp.redux.store
import tw.geothings.rekotlin.StoreSubscriber
import java.io.ByteArrayOutputStream

class MoreFragment : BaseStartEmergencyFragment(), StoreSubscriber<HomeState> {

    private lateinit var binding: FragmentMoreBinding

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?,
    ): View {
        binding = FragmentMoreBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)

        btnEmergency.configure(
                buttonText = getString(R.string.emergency),
                mainColorId = R.color.coralRed,
                textSize = 16
        ) {
            startEmergency()
        }

        btnSettings.configure(
                buttonText = getString(R.string.settings),
                iconId = R.drawable.ic_settings,
                textSize = 14
        )
        btnSettings.visibility = View.GONE

        btnMyAccount.configure(
                buttonText = getString(R.string.my_account),
                iconId = R.drawable.ic_profile,
                textSize = 14
        ) {
            activity?.startActivityForResult(Intent(context, MyAccountActivity::class.java), REQUEST_CODE_MY_ACCOUNT)
        }
    }

    private fun pickBuddyFromContacts() {
        when (ContextCompat.checkSelfPermission(requireContext(), Manifest.permission.READ_CONTACTS)) {
            PackageManager.PERMISSION_GRANTED -> {
                val intent = Intent(Intent.ACTION_PICK).apply {
                    type = ContactsContract.CommonDataKinds.Phone.CONTENT_TYPE
                }

                startActivityForResult(intent, SELECT_PHONE_NUMBER)
            }
            else -> requestPermissions(listOf(Manifest.permission.READ_CONTACTS).toTypedArray(), REQUEST_READ_CONTACTS)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        when (requestCode) {
            REQUEST_READ_CONTACTS -> {
                if (grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) {
                    pickBuddyFromContacts()
                } else {
                    Toast.makeText(requireContext(), "Can't access contacts ...", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SELECT_PHONE_NUMBER && resultCode == Activity.RESULT_OK) {
            val contactUri = data?.data ?: return
            val projection = arrayOf(
                    ContactsContract.CommonDataKinds.Phone.NUMBER,
                    ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
                    ContactsContract.CommonDataKinds.Phone.PHOTO_THUMBNAIL_URI
            )
            val cursor = requireContext().contentResolver.query(contactUri, projection, null, null, null)

            if (cursor != null && cursor.moveToFirst()) {
                val number = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER))
                val name = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME))
                val photoThumbnailPath = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_THUMBNAIL_URI))

                store.dispatch(HomeRequests.AddBuddy(ApiAddBuddy(number, name, convertToBase64(photoThumbnailPath))))
            }
            cursor?.close()
        }
    }

    private fun convertToBase64(photoThumbnailPath: String?): String? {
        if (photoThumbnailPath == null) return null

        val imageStream = requireContext().contentResolver.openInputStream(Uri.parse(photoThumbnailPath))
        val outputStream = ByteArrayOutputStream()
        BitmapFactory.decodeStream(imageStream).apply { compress(Bitmap.CompressFormat.JPEG, 100, outputStream) }
        return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT)
    }

    override fun onNewState(state: HomeState) {
        binding.buddiesCard.configure(
                state.buddies.toBuddyItems(requireContext()),
                onBuddyTap = { index ->
                    showRemoveBuddyAlert(state.buddies[index])
                }
        ) { pickBuddyFromContacts() }
    }

    private fun showRemoveBuddyAlert(buddy: Buddy) = context?.let { context ->
        AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.delete_buddy))
                .setMessage(context.getString(R.string.delete_buddy_explanation, buddy.fullName))
                .setCancelable(false)
                .setPositiveButton(context.getString(R.string.yes)) { _, _ ->
                    store.dispatch(HomeRequests.RemoveBuddy(buddy))
                }
                .setNegativeButton(context.getString(R.string.no), null)
                .create()
                .show()
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.home.buddies == newState.home.buddies
            }.select { it.home }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    companion object {

        private const val SELECT_PHONE_NUMBER = 111
        private const val REQUEST_READ_CONTACTS = 112
        const val REQUEST_CODE_MY_ACCOUNT = 100
    }
}
