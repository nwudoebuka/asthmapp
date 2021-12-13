package com.asthmapp.android.features

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.asthmapp.android.R
import com.asthmapp.android.databinding.ActivityMainBinding
import com.asthmapp.android.features.add_data.AddDataActivity
import com.asthmapp.android.features.alert.AlertActivity
import com.asthmapp.android.features.home.HomeFragment
import com.asthmapp.android.features.learn.LearnFragment
import com.asthmapp.android.features.more.MoreFragment
import com.asthmapp.android.features.more.MoreFragment.Companion.REQUEST_CODE_MY_ACCOUNT
import com.asthmapp.android.features.notifications.NotificationsFragment
import com.asthmapp.android.features.onboarding.OnboardingActivity
import com.asthmapp.android.features.subscription.SubscriptionActivity
import com.asthmapp.features.auth_client.requests.IAuthRequests
import com.asthmapp.features.emergency.redux.EmergencyRequests
import com.asthmapp.features.emergency.redux.EmergencyState
import com.asthmapp.features.home.redux.HomeRequests
import com.asthmapp.features.learn.redux.LearnRequests
import com.asthmapp.features.notifications.redux.NotificationsRequests
import com.asthmapp.redux.store
import com.asthmapp.utils.settings
import com.google.firebase.auth.FirebaseAuth
import tw.geothings.rekotlin.StoreSubscriber

class MainActivity : AppCompatActivity(), StoreSubscriber<EmergencyState> {

    private val currentTabFragment: Fragment?
        get() = supportFragmentManager.fragments.lastOrNull()

    private var selectedHomeTab = HomeTab.HOME

    private val binding by lazy { ActivityMainBinding.inflate(layoutInflater) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        initViews()
        fetchData()

        if (!settings.getIsOnboardingShown()) startActivity(Intent(this, OnboardingActivity::class.java))
    }

    private fun initViews() = with(binding) {
        setSupportActionBar(toolbar)

        bottomNavigation.setOnNavigationItemSelectedListener { item ->
            val homeTab = HomeTab.fromMenuItemId(item.itemId)
            if (homeTab != selectedHomeTab) {
                selectedHomeTab = homeTab
                updateFragment()
            }
            true
        }

        updateFragment()

        buttonRemoveAll.setOnClickListener {
            store.dispatch(NotificationsRequests.DeleteAllNotifications())
        }
    }

    private fun updateFragment() = with(binding) {
        tvPageTitle.text = getString(selectedHomeTab.titleId)

        val bottomNavSelectedItemId = selectedHomeTab.menuItemId
        if (bottomNavigation.selectedItemId != bottomNavSelectedItemId) {
            bottomNavigation.selectedItemId = bottomNavSelectedItemId
        }

        val fragment: Fragment = when (selectedHomeTab) {
            HomeTab.HOME -> {
                currentTabFragment as? HomeFragment ?: HomeFragment()
            }
            HomeTab.LEARN -> {
                currentTabFragment as? LearnFragment ?: LearnFragment()
            }
            HomeTab.NOTIFICATIONS -> {
                currentTabFragment as? NotificationsFragment ?: NotificationsFragment()
            }
            HomeTab.MORE -> {
                currentTabFragment as? MoreFragment ?: MoreFragment()
            }
        }

        updateToolbar()

        supportFragmentManager
                .beginTransaction()
                .replace(R.id.fragment_container, fragment)
                .commit()
    }

    private fun updateToolbar() {
        binding.buttonRemoveAll.visibility = if (selectedHomeTab == HomeTab.NOTIFICATIONS) View.VISIBLE else View.GONE
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_CODE_MY_ACCOUNT) {
            if (resultCode == RESULT_CANCELED) {
                logOut()
            }
        }
    }

    private fun logOut() {
        FirebaseAuth.getInstance().signOut()
        store.dispatch(IAuthRequests.LogOut())
        startActivity(Intent(this, SplashActivity::class.java))
        finish()
    }

    private fun fetchData() {
        store.dispatch(NotificationsRequests.FetchNotifications())
        store.dispatch(LearnRequests.FetchNews())
        store.dispatch(HomeRequests.FetchHome())
        store.dispatch(EmergencyRequests.GetEmergency())
    }

    enum class HomeTab(val titleId: Int, val menuItemId: Int) {

        HOME(R.string.home, R.id.navHome),
        LEARN(R.string.learn, R.id.navLearn),
        NOTIFICATIONS(R.string.notifications, R.id.navNotifications),
        MORE(R.string.more, R.id.navMore);

        companion object {

            fun fromMenuItemId(menuItemId: Int): HomeTab =
                    enumValues<HomeTab>().find { it.menuItemId == menuItemId } ?: HOME
        }
    }

    override fun onNewState(state: EmergencyState) {
        if (state.emergency != null) {
            startActivity(Intent(this, AlertActivity::class.java))
        }
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.emergency == newState.emergency
            }.select { it.emergency }
        }

        changeFabUI()
    }

    private fun changeFabUI() = with(binding) {
        if (settings.getIsSubscribed()) {
            fab.setImageResource(R.drawable.ic_plus)
            fab.setOnClickListener {
                startActivity(Intent(this@MainActivity, AddDataActivity::class.java))
                overridePendingTransition(R.anim.bottom_up, R.anim.nothing)
            }
        } else {
            fab.setImageResource(R.drawable.ic_lock)
            fab.setOnClickListener {
                startActivity(SubscriptionActivity.newIntent(this@MainActivity))
                overridePendingTransition(R.anim.bottom_up, R.anim.nothing)
            }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }
}
