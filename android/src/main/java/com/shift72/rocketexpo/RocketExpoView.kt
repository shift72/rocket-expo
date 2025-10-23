package com.shift72.rocketexpo

import android.content.Context
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

import com.shift72.mobile.rocketsdk.player.PlaybackCallback
import com.shift72.mobile.rocketsdk.player.RocketPlayer
import com.shift72.mobile.rocketsdk.player.RocketPlayerListener
import com.shift72.mobile.rocketsdk.player.RocketSurface
import com.shift72.mobile.rocketsdk.RocketPlayerLogger
import com.shift72.mobile.rocketsdk.launchpad.RocketPlayerLaunchpadBase

import com.google.android.exoplayer2.ui.StyledPlayerView
import com.google.android.exoplayer2.SimpleExoPlayer
import android.os.Looper

import android.view.MotionEvent
import android.widget.FrameLayout

import android.os.Handler
import java.lang.Runnable

class RocketExpoView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  private val onPlaybackCompleted by EventDispatcher()

  companion object { // Static variables
    var hostname = ""
    var playerLogger: RocketPlayerListener = RocketPlayerLogger()
  }

  fun onRocketComplete() {
    android.util.Log.d("TAG", "onRocketComplete: its done")
    onPlaybackCompleted(emptyMap())
  }

  internal val playerView: RocketSurface = RocketSurface(context).apply {
    layoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.MATCH_PARENT
    )  }

  internal val player: RocketPlayer

  init {
    if (hostname.isEmpty()){
      appContext.jsLogger?.fatal("you must set a hostname")
    }
    assert(!hostname.isEmpty()) {"you must set a hostname"}

    player = RocketPlayerLaunchpadBase
      .MakeRocketPlayerLaunchpad(context, playerView)
      .setBaseUrl(hostname)
      .setRocketPlayerListener(playerLogger)
      .setRocketOnCompleteCallback(this::onRocketComplete)
      .build()
    playerView.showController();
    addView(playerView)
  }
}
