package com.asthmapp.android.features.notifications

import android.app.PendingIntent.getActivity
import android.content.Intent
import android.os.Bundle
import android.provider.Settings.Global.getString
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.asthmapp.android.R
import com.asthmapp.android.databinding.FragmentNotificationsBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.android.features.add_data.AddDataActivity
import com.asthmapp.android.features.add_data.WebViewActivity
import com.asthmapp.android.features.alert.BaseStartEmergencyFragment
import com.asthmapp.android.features.notifications.epoxyModels.NotificationEpoxyModel
import com.asthmapp.android.shared.EmergencyEpoxyModel
import com.asthmapp.features.notifications.entity.Notification
import com.asthmapp.features.notifications.redux.NotificationsState
import com.asthmapp.redux.store
import com.asthmapp.utils.Constants
import tw.geothings.rekotlin.StoreSubscriber

class NotificationsFragment : BaseStartEmergencyFragment(), StoreSubscriber<NotificationsState> {

    private lateinit var binding: FragmentNotificationsBinding
    private val epoxyController = EpoxyController(
            shouldOpenLink = { link ->
                openWebView(link)
            },
            shouldOpenAddData = ::openAddData,
            onEmergencyTap = ::startEmergency,
            closeNotification = { notificationItem ->
                closeNotification(notificationItem)
            }
    )

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentNotificationsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)
        recyclerView.adapter = epoxyController.adapter
        //epoxyController.recycV = recyclerView
        recyclerView.layoutManager = LinearLayoutManager(requireContext())
    }

    override fun onNewState(state: NotificationsState) {
        epoxyController.data = state.notifications.map { NotificationItem(it) } as MutableList<NotificationItem>
    }

    private fun openWebView(link: String) = context?.let { context ->
        context.startActivity(WebViewActivity.newIntent(context, link, ""))
    }

    private fun closeNotification(notificationItem: NotificationItem) {
        epoxyController.removeItem(notificationItem)
    }

    private fun openAddData() = context?.let { context ->
        context.startActivity(Intent(context, AddDataActivity::class.java))
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.notifications == newState.notifications
            }.select { it.notifications }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    private class EpoxyController(
            private val shouldOpenLink: (String) -> Unit,
            private val shouldOpenAddData: () -> Unit,
            private val onEmergencyTap: () -> Unit,
            private val closeNotification: (NotificationItem) -> Unit
    ) : BaseEpoxyController<NotificationItem>() {

//        lateinit var recycV:RecyclerView

        override fun buildModels() {
            EmergencyEpoxyModel { onEmergencyTap() }.addTo(this)
            Log.i("dataNoti",data.toString())
            data?.forEach { notificationItem ->
                NotificationEpoxyModel(notificationItem) {
                    notificationItem.link?.let { link ->
                        shouldOpenLink(link)
                    }
                    if (notificationItem.type == Notification.Type.ADD_DATA) {
                        shouldOpenAddData()
                    }

                    closeNotification(notificationItem)

                }.addTo(this)
            }
        }
    }
}
