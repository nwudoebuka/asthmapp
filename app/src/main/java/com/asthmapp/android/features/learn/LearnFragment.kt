package com.asthmapp.android.features.learn

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.asthmapp.android.databinding.FragmentLearnBinding
import com.asthmapp.android.epoxy.BaseEpoxyController
import com.asthmapp.android.features.alert.BaseStartEmergencyFragment
import com.asthmapp.android.features.learn.epoxyModels.ArticleEpoxyModel
import com.asthmapp.android.features.learn.epoxyModels.SearchEpoxyModel
import com.asthmapp.android.features.learn.epoxyModels.VideoEpoxyModel
import com.asthmapp.android.shared.EmergencyEpoxyModel
import com.asthmapp.features.learn.entity.LearnNews
import com.asthmapp.features.learn.redux.LearnRequests
import com.asthmapp.features.learn.redux.LearnState
import com.asthmapp.redux.store
import tw.geothings.rekotlin.StoreSubscriber

class LearnFragment : BaseStartEmergencyFragment(), StoreSubscriber<LearnState> {

    private lateinit var binding: FragmentLearnBinding

    private val epoxyController = EpoxyController(
            onTextChanged = { query ->
                store.dispatch(LearnRequests.FilterNews(query))
            },
            onEmergencyTap = ::startEmergency
    )

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        binding = FragmentLearnBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) = with(binding) {
        super.onViewCreated(view, savedInstanceState)
        recyclerView.adapter = epoxyController.adapter
        recyclerView.layoutManager = LinearLayoutManager(requireContext())
    }

    override fun onNewState(state: LearnState) {
        epoxyController.data = state.filteredNews.toNewsItems() as MutableList<LearnNewsItem>
    }

    private fun List<LearnNews>.toNewsItems() = map {
        when (it) {
            is LearnNews.Video -> {
                return@map LearnNewsItem.Video(it)
            }
            is LearnNews.Article -> {
                return@map LearnNewsItem.Article(it)
            }
        }
    }

    override fun onStart() {
        super.onStart()
        store.subscribe(this) { state ->
            state.skipRepeats { oldState, newState ->
                oldState.learn == newState.learn
            }.select { it.learn }
        }
    }

    override fun onStop() {
        super.onStop()
        store.unsubscribe(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        store.dispatch(LearnRequests.Destroy)
    }

    private class EpoxyController(
            private val onTextChanged: (String) -> Unit,
            private val onEmergencyTap: () -> Unit
    ) : BaseEpoxyController<LearnNewsItem>() {

        override fun buildModels() {
            EmergencyEpoxyModel { onEmergencyTap() }.addTo(this)
            SearchEpoxyModel { onTextChanged(it) }.addTo(this)
            data?.forEach {
                when (it) {
                    is LearnNewsItem.Video -> VideoEpoxyModel(it).addTo(this)
                    is LearnNewsItem.Article -> ArticleEpoxyModel(it).addTo(this)
                }
            }
        }
    }
}
