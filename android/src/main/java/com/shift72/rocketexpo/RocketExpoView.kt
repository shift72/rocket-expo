package com.shift72.rocketexpo

import android.content.Context
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView

import com.shift72.mobile.rocketsdk.player.PlaybackCallback;
import com.shift72.mobile.rocketsdk.player.RocketPlayer;
import com.shift72.mobile.rocketsdk.player.RocketPlayerListener;
import com.shift72.mobile.rocketsdk.player.RocketSurface;
import com.shift72.mobile.rocketsdk.launchpad.RocketPlayerLaunchpadBase;

import com.google.android.exoplayer2.ui.StyledPlayerView;
import com.google.android.exoplayer2.SimpleExoPlayer;
import android.os.Looper;

import android.view.MotionEvent
import android.widget.FrameLayout;

import android.os.Handler;
import java.lang.Runnable

class RocketExpoView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  // Creates and initializes an event dispatcher for the `onLoad` event.
  // The name of the event is inferred from the value and needs to match the event name defined in the module.
  private val onLoad by EventDispatcher()

  fun onRocketComplete() {
    android.util.Log.d("TAG", "onRocketComplete: its done")
  }

  internal var playerView: RocketSurface = RocketSurface(context).apply {
    layoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.MATCH_PARENT
    )  }

  internal val player: RocketPlayer = RocketPlayerLaunchpadBase
    .MakeRocketPlayerLaunchpad(context, playerView)
    .setBaseUrl("")
    .setRocketOnCompleteCallback(this::onRocketComplete)
    .build()

  init {
    playerView.showController();
    addView(playerView)  }
}
