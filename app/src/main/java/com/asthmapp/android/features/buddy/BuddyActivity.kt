package com.asthmapp.android.features.buddy

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityBuddyBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.android.features.SplashActivity
import com.asthmapp.features.auth_buddy.requests.IAuthBuddyRequests
import com.asthmapp.features.buddy.BuddyUser
import com.asthmapp.features.buddy.redux.BuddyRequests
import com.asthmapp.features.buddy.redux.BuddyState
import com.asthmapp.redux.store
import com.google.firebase.auth.FirebaseAuth
import tw.geothings.rekotlin.StoreSubscriber

class BuddyActivity : AppCompatActivity(), StoreSubscriber<BuddyState> {

    private val epoxyController = EpoxyController()

    private val binding by lazy { ActivityBuddyBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) = with(binding) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        recyclerView.adapter = epoxyController.adapter
        recyclerView.layoutManager = LinearLayoutManager(this@BuddyActivity, LinearLayoutManager.VERTICAL, false)
        store.dispatch(BuddyRequests.FetchBuddyUsers())

        icLogout.setOnClickListener {
            showLogout()
        }
    }

    private fun showLogout() = AlertDialog.Builder(this)
            .setTitle(getString(R.string.log_out))
            .setMessage(getString(R.string.do_you_want_to_log_out))
            .setCancelable(false)
            .setPositiveButton(getString(R.string.stay_logged_in), null)
            .setNegativeButton(getString(R.string.log_out)) { _, _ ->
                FirebaseAuth.getInstance().signOut()
                store.dispatch(IAuthBuddyRequests.LogOut())
                startActivity(Intent(this, SplashActivity::class.java))
                finish()
            }
            .create()
            .show()

    private class EpoxyController : BaseEpoxyController<BuddyUser>() {

        override fun buildModels() {
            data?.forEach {
                BuddyUserEpoxyModel(it).addTo(this)
            }
        }
    }

    override fun onNewState(state: BuddyState) = with(binding) {
        when (state.status) {
            BuddyState.Status.PENDING -> {
                tvNoBuddies.visibility = View.GONE
                spinner.root.visibility = View.VISIBLE
            }
            BuddyState.Status.IDLE -> {
                tvNoBuddies.visibility = if (state.buddyUsers.isEmpty()) View.VISIBLE else View.GONE
                spinner.root.visibility = View.GONE
            }
        }

        epoxyController.data = state.buddyUsers as MutableList<BuddyUser>
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.buddy == newState.buddy
            }.select { it.buddy }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }
}
