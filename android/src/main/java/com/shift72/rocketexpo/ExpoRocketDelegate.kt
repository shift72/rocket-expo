package com.shift72.rocketexpo

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import com.shift72.mobile.rocketsdk.R
import com.shift72.mobile.rocketsdk.core.RocketDelegate
import com.shift72.mobile.rocketsdk.core.action.PlaybackProgressAction
import com.shift72.mobile.rocketsdk.core.action.WatchWindowAction
import java.lang.ref.WeakReference

class ExpoRocketDelegate(val context: Context, val module: WeakReference<RocketExpoModule>, val onPlaybackEnded: () -> Unit): RocketDelegate {

    override fun onWatchWindow(action: WatchWindowAction, timeToWatch: String) {
        val watchText: String = context.getString(R.string.rocketsdk_watch_now_action)
        val alertDialogText: String =
            context.getString(R.string.rocketsdk_watch_window_dialog_text, watchText, timeToWatch)
        val builder = AlertDialog.Builder(context)
        builder.setMessage(alertDialogText)
            .setTitle(context.getString(R.string.rocketsdk_watch_window_title))
            .setPositiveButton(
                watchText,
                DialogInterface.OnClickListener { dialogInterface: DialogInterface?, i: Int ->
                    action.startWatchWindow()
                })
            .setNegativeButton(context.getString(R.string.rocketsdk_cancel)) { dialogInterface, i ->
                action.cancel()
            }
            .setCancelable(false)

        val dialog = builder.create()
        dialog.show()
    }

    override fun onFoundPlaybackProgress(
        action: PlaybackProgressAction,
        position: Int,
        length: Int
    ) {
        val hours = position / 3600
        val minutes = (position % 3600) / 60
        val seconds = position % 60

        val resumePos = String.format("%02d:%02d:%02d", hours, minutes, seconds)

        val builder = AlertDialog.Builder(context)
        builder.setMessage(context.getString(R.string.rocketsdk_resume_from_dialog_text, resumePos))
            .setTitle(context.getString(R.string.rocketsdk_resume_from_title))
            .setPositiveButton(context.getString(R.string.rocketsdk_resume_from_resume_action)) { dialogInterface, i ->
                action.resumePlaybackFromProgress()
            }
            .setNegativeButton(context.getString(R.string.rocketsdk_cancel)) { dialogInterface, i ->
                action.cancel()
            }
            .setNeutralButton(context.getString(R.string.rocketsdk_resume_from_start_over_action)) { dialogInterface, i ->
                action.startOverFromBeginning()
            }.setCancelable(false)

        val dialog = builder.create()
        dialog.show()
    }

    override fun onTooManyDevicesPlaybackAborted() {
        val builder = AlertDialog.Builder(context)
        builder.setMessage(context.getString(R.string.rocketsdk_too_many_devices_dialog_text))
            .setTitle(context.getString(R.string.rocketsdk_too_many_devices_title))
            .setNegativeButton(context.getString(R.string.rocketsdk_ok)) { dialogInterface, i ->
                doErrorAbort("too_many_devices")
            }
            .setCancelable(false)

        val dialog = builder.create()
        dialog.show()
    }

    override fun onTooManyConcurrentStreamsPlaybackAborted() {
        val builder = AlertDialog.Builder(context)
        builder.setMessage(context.getString(R.string.rocketsdk_too_many_concurrent_streams_dialog_text))
            .setTitle(context.getString(R.string.rocketsdk_too_many_concurrent_streams_title))
            .setNegativeButton(context.getString(R.string.rocketsdk_ok)) { dialogInterface, i ->
                doErrorAbort("too_many_streams")
            }
            .setCancelable(false)
    }

    override fun onPlaybackCompleted(reason: RocketDelegate.CompletionReason) {
        when (reason) {
            RocketDelegate.CompletionReason.REACHED_END -> {
                module.get()?.sendEvent("onPlaybackCompleted", emptyMap())
                onPlaybackEnded()
            }
            RocketDelegate.CompletionReason.ERROR -> {
                doErrorAbort("generic")
            }
            RocketDelegate.CompletionReason.USER_ABORTED -> {
                doUserAbort()
            }
        }
    }

    override fun onErrorPlaybackAborted() {
        val builder = AlertDialog.Builder(context)
        builder.setMessage(context.getString(R.string.rocketsdk_playback_error_dialog_text))
            .setTitle(context.getString(R.string.rocketsdk_error_title))
            .setNegativeButton(context.getString(R.string.rocketsdk_ok)) { dialogInterface, i ->
                doErrorAbort("generic")
            }
            .setCancelable(false)

        val dialog = builder.create()
        dialog.show()
    }

    override fun onAuthorizationErrorPlaybackAborted() {
        val builder = AlertDialog.Builder(context)
        builder.setMessage(context.getString(R.string.rocketsdk_too_many_devices_unauthorized_error_dialog_text))
            .setTitle(context.getString(R.string.rocketsdk_error_title))
            .setNegativeButton(context.getString(R.string.rocketsdk_ok)) { dialogInterface, i ->
                doErrorAbort("authorization")
            }
            .setCancelable(false)

        val dialog = builder.create()
        dialog.show()
    }

    override fun onPaused() {
        module.get()?.sendEvent("onPause", emptyMap())
    }

    override fun onPlaying() {
        module.get()?.sendEvent("onPlay", emptyMap())
    }

    override fun onBuffering() {
        module.get()?.sendEvent("onBuffering", emptyMap())
    }

    override fun onProgressUpdate(elapsedSeconds: Double, runtimeSeconds: Double) {
        module.get()?.sendEvent("onProgressUpdate", mapOf("elapsedSeconds" to elapsedSeconds, "runtimeSeconds" to runtimeSeconds))
    }

    private fun doUserAbort() {
        module.get()?.sendEvent("onUserPlaybackAborted", emptyMap())
        onPlaybackEnded()
    }

    private fun doErrorAbort(type: String) {
        module.get()?.sendEvent("onErrorPlaybackAborted", mapOf("type" to type))
        onPlaybackEnded()
    }

}