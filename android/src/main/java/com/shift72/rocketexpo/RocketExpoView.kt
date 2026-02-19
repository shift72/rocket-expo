package com.shift72.rocketexpo

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.widget.FrameLayout
import com.shift72.mobile.rocketsdk.RocketPlayerLogger
import com.shift72.mobile.rocketsdk.core.RocketDelegate
import com.shift72.mobile.rocketsdk.core.a
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

  private val onPlaybackCompleted by EventDispatcher()

  private val onTimeChanged by EventDispatcher()
  private val onPaused by EventDispatcher()
  private val onPlay by EventDispatcher()
  private val onFullscreenEnter by EventDispatcher()
  private val onFullscreenExit by EventDispatcher()

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

  internal var player: RocketPlayer? = null

  internal var config: PlaybackConfig? = null

  internal val rocketDelegateListener = object: RocketDelegate {
    override fun onWatchWindow(action: WatchWindowAction?, timeToWatch: String?) {
      action ?: return

      val watchText: String = context.getString(RocketSdkR.string.rocketsdk_watch_now_action)
      val alertDialogText: String =
        context.getString(RocketSdkR.string.rocketsdk_watch_window_dialog_text, watchText, timeToWatch)
      val builder = AlertDialog.Builder(context)
      builder.setMessage(alertDialogText)
        .setTitle(context.getString(RocketSdkR.string.rocketsdk_watch_window_title))
        .setPositiveButton(
          watchText,
          DialogInterface.OnClickListener { dialogInterface: DialogInterface?, i: Int ->
            action.startWatchWindow()
          })
        .setNegativeButton(context.getString(RocketSdkR.string.rocketsdk_cancel)) { dialogInterface, i ->
          action.cancel()
        }
        .setCancelable(false)

      val dialog = builder.create()
      dialog.show()
    }

    override fun onFoundPlaybackProgress(
      action: PlaybackProgressAction?,
      position: Int,
      length: Int
    ) {
      action?: return

      val hours = position / 3600
      val minutes = (position % 3600) / 60
      val seconds = position % 60

      val resumePos = String.format("%02d:%02d:%02d", hours, minutes, seconds)

      val builder = AlertDialog.Builder(context)
      builder.setMessage(context.getString(RocketSdkR.string.rocketsdk_resume_from_dialog_text, resumePos))
//        .setTitle(context.getString(RocketSdkR.string.rocketsdk_resume_from_title))
        .setTitle("WOWOWOWO")
        .setPositiveButton(context.getString(RocketSdkR.string.rocketsdk_resume_from_resume_action)) { dialogInterface, i ->
          action.resumePlaybackFromProgress()
        }
        .setNegativeButton(context.getString(RocketSdkR.string.rocketsdk_cancel)) { dialogInterface, i ->
          action.cancel()
        }
        .setNeutralButton(context.getString(RocketSdkR.string.rocketsdk_resume_from_start_over_action)) { dialogInterface, i ->
          action.startOverFromBeginning()
        }.setCancelable(false)

      val dialog = builder.create()
      dialog.show()
    }

    override fun onTooManyDevicesPlaybackAborted() {
      val builder = AlertDialog.Builder(context)
      builder.setMessage(context.getString(RocketSdkR.string.rocketsdk_too_many_devices_dialog_text))
        .setTitle(context.getString(RocketSdkR.string.rocketsdk_too_many_devices_title))
        .setNegativeButton(context.getString(RocketSdkR.string.rocketsdk_ok)) { dialogInterface, i ->
          this@RocketExpoView.onPlaybackCompleted(emptyMap())
        }
        .setCancelable(false)

      val dialog = builder.create()
      dialog.show()
    }

    override fun onTooManyConcurrentStreamsPlaybackAborted() {

      TODO("Not yet implemented")
    }

    override fun onPlaybackCompleted(reason: a?) {
      this@RocketExpoView.onPlaybackCompleted(emptyMap())
    }

    override fun onErrorPlaybackAborted() {
      val builder = AlertDialog.Builder(context)
      builder.setMessage(context.getString(RocketSdkR.string.rocketsdk_playback_error_dialog_text))
        .setTitle(context.getString(RocketSdkR.string.rocketsdk_error_title))
        .setNegativeButton(context.getString(RocketSdkR.string.rocketsdk_ok)) { dialogInterface, i ->
          this@RocketExpoView.onPlaybackCompleted(emptyMap())
        }
        .setCancelable(false)

      val dialog = builder.create()
      dialog.show()
    }

    override fun onAuthorizationErrorPlaybackAborted() {
      val builder = AlertDialog.Builder(context)
      builder.setMessage(context.getString(RocketSdkR.string.rocketsdk_too_many_devices_unauthorized_error_dialog_text))
        .setTitle(context.getString(RocketSdkR.string.rocketsdk_error_title))
        .setNegativeButton(context.getString(RocketSdkR.string.rocketsdk_ok)) { dialogInterface, i ->
          this@RocketExpoView.onPlaybackCompleted(emptyMap())
        }
        .setCancelable(false)

      val dialog = builder.create()
      dialog.show()
    }

  }

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

    if (hostname.isEmpty()){
      appContext.errorManager?.reportWarningToLogBox("you must set a hostname")
    }
    assert(!hostname.isEmpty()) {"you must set a hostname"}

    player = RocketPlayerLaunchpadBase
      .MakeRocketPlayerLaunchpad(context, playerView)
      .setBaseUrl(hostname)
      .setRocketPlayerListener(playerLogger)
      .setRocketDelegate(rocketDelegateListener)
      //.setRocketOnCompleteCallback(this::onRocketComplete)
      .build()
    playerView.showController();
    addView(playerView)
    player?.play(config?.slug, config?.token);
  }

}
