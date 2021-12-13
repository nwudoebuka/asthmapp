package com.asthmapp.android.features.add_data

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.KeyEvent
import android.view.KeyEvent.KEYCODE_BACK
import android.view.View
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.asthmapp.android.databinding.ActivityWebPageBinding

class WebViewActivity : AppCompatActivity() {

    private val binding by lazy { ActivityWebPageBinding.inflate(layoutInflater) }

    private val pageTitle: String
        get() = intent.getStringExtra(PAGE_TITLE_ID).orEmpty()

    private val link: String
        get() = intent.getStringExtra(PAGE_LINK_ID).orEmpty()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        initToolbar()
        initViews()
    }

    private fun initToolbar() {
        setSupportActionBar(binding.toolbar)
        supportActionBar?.run {
            setDisplayHomeAsUpEnabled(true)
            setDisplayShowHomeEnabled(true)
        }
    }

    private fun initViews() = with(binding) {
        toolbar.title = pageTitle
        setupWebView()
        swipeRefreshLayout.setOnRefreshListener { webView.reload() }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView() = with(binding.webView) {
        loadUrl(link)

        settings.apply {
            javaScriptEnabled = true
            layoutAlgorithm = WebSettings.LayoutAlgorithm.SINGLE_COLUMN
            useWideViewPort = true
            builtInZoomControls = true
            displayZoomControls = false
        }
        webViewClient = object : WebViewClient() {

            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                loadUrl(url)
                return true
            }

            override fun onPageFinished(view: WebView, url: String) = with(binding) {
                progressBarHorizontal.visibility = View.GONE
                webView.visibility = View.VISIBLE
                swipeRefreshLayout.isRefreshing = false
            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        when (keyCode) {
            KEYCODE_BACK -> {
                if (binding.webView.canGoBack()) {
                    binding.webView.goBack()
                } else {
                    finish()
                }
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressed()
        return true
    }

    companion object {

        private const val PAGE_TITLE_ID = "page_title_id"
        private const val PAGE_LINK_ID = "page_link_id"

        fun newIntent(
                context: Context,
                link: String,
                title: String
        ) = Intent(context, WebViewActivity::class.java).apply {
            putExtra(PAGE_TITLE_ID, title)
            putExtra(PAGE_LINK_ID, link)
        }
    }
}
