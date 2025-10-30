package com.shift72.rocketexpo

import android.os.Bundle

import expo.modules.kotlin.AppContext

import com.shift72.mobile.rocketsdk.core.error.RocketPlayErrorBase
import com.shift72.mobile.rocketsdk.core.error.RocketSdkError
import com.shift72.mobile.rocketsdk.player.RocketPlayerListener

public class RocketExpoLogger (val appContext: AppContext, val prefix: String? = null) : RocketPlayerListener {
    override fun onFatalError(error: RocketSdkError) {
        if (error.cause != null){
            appContext.errorManager?.reportWarningToLogBox("${prefix}: ${error.rocketErrorCode} - onFatalError: ${error.message}; inner: ${error.cause?.message}")
        } else {
            appContext.errorManager?.reportWarningToLogBox("${prefix}: ${error.rocketErrorCode} - onFatalError: ${error.message}; no inner")
        }
    }

    override fun onPlaybackError(error: RocketPlayErrorBase) {
        if (error.hasThrowable()){
            appContext.errorManager?.reportWarningToLogBox("${prefix}: ${error.rocketErrorCode} - onPlaybackError: ${error.throwable.message}")
        } else {
            appContext.errorManager?.reportWarningToLogBox("${prefix}: ${error.rocketErrorCode} - onPlaybackError: no extra information")
        }
    }

    override fun onPlayerEvent(message: String, bundle: Bundle): Unit {
        appContext.errorManager?.reportWarningToLogBox("${prefix}: PlayerEvent ${message} - ${bundle.toString()}")
    }
}