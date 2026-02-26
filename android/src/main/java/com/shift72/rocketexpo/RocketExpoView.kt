package com.shift72.rocketexpo

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.util.Log
import android.widget.FrameLayout
import com.shift72.mobile.rocketsdk.RocketPlayerLogger
import com.shift72.mobile.rocketsdk.core.RocketDelegate
import com.shift72.mobile.rocketsdk.core.action.PlaybackProgressAction
import com.shift72.mobile.rocketsdk.core.action.WatchWindowAction
import com.shift72.mobile.rocketsdk.launchpad.RocketPlayerLaunchpadBase
import com.shift72.mobile.rocketsdk.player.RocketPlayer
import com.shift72.mobile.rocketsdk.player.RocketPlayerListener
import com.shift72.mobile.rocketsdk.player.RocketSurface
import com.shift72.rocketexpo.RocketExpoModule.PlaybackConfig
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.viewevent.EventDispatcher
import expo.modules.kotlin.views.ExpoView
import com.shift72.mobile.rocketsdk.R as RocketSdkR


class RocketExpoView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {


  companion object { // Static variables
    var hostname = ""
    var playerLogger: RocketPlayerListener = RocketPlayerLogger()
  }

  fun onRocketComplete() {
    android.util.Log.d("TAG", "onRocketComplete: its done")
  }

  internal val playerView: RocketSurface = RocketSurface(context).apply {
    layoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.MATCH_PARENT
    )  }

  internal var player: RocketPlayer? = null

  internal var config: PlaybackConfig? = null

//  internal val rocketDelegateListener = object

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    android.util.Log.d("TAG", "onDetachedFromWindow: we detatched")
    // Perform cleanup tasks here, like stopping animations,
    // unregistering listeners, or canceling background threads/coroutines.
    player?.destroy()
    removeView(playerView)
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()

    val rocketDelegate = ExpoRocketDelegate(context, RocketExpoModule.mod!!, this::onRocketComplete)


    if (hostname.isEmpty()){
      appContext.errorManager?.reportWarningToLogBox("you must set a hostname")
    }
    assert(!hostname.isEmpty()) {"you must set a hostname"}

    player = RocketPlayerLaunchpadBase
      .MakeRocketPlayerLaunchpad(context, playerView)
      .setBaseUrl(hostname)
      .setRocketPlayerListener(playerLogger)
      .setRocketDelegate(rocketDelegate)
      .build()
    playerView.showController();
    addView(playerView)
    player?.play(config?.slug, config?.token);
  }

}
