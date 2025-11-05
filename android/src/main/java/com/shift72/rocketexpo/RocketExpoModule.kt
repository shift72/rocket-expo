package com.shift72.rocketexpo

import android.content.Context
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import expo.modules.kotlin.records.Record
import expo.modules.kotlin.records.Field
import expo.modules.kotlin.exception.Exceptions

import android.util.Log
import com.shift72.rocketexpo.ScreenActivity

import android.content.Intent

import com.shift72.rocketexpo.RocketExpoLogger

class RocketExpoModule : Module() {


  override fun definition() = ModuleDefinition {

    Name("RocketExpo")

    Function("setupHostname") { hostname: String ->
      RocketExpoView.hostname = hostname
    }

    Function("openPlayerFullscreen") { config: PlaybackConfig ->
      val context: Context = appContext.currentActivity ?: throw Exceptions.ReactContextLost()
      android.util.Log.d("TAG", "openPlayerFullscreen: ")
      val myIntent = Intent(context, ScreenActivity::class.java).apply {
        putExtra("slug", config.slug)
        putExtra("token", config.token)
      }
      context.startActivity(myIntent)
    }

    Function("setupLogger") { prefix: String ->
      RocketExpoView.playerLogger = RocketExpoLogger(appContext, prefix)
    }

    OnActivityDestroys() {
      android.util.Log.d("TAG", "OnActivityDestroys")
    }

    // Enables the module to be used as a native view. Definition components that are accepted as part of
    // the view definition: Prop, Events.
    View(RocketExpoView::class) {
      // Defines a setter for the `url` prop.
      Prop("playbackConfig") { view: RocketExpoView, config: PlaybackConfig ->
        if (!config.slug.isEmpty() && !config.token.isEmpty()) {
          view.config = config;
        }
      }
      // Defines an event that the view can send to JavaScript.
      Events("onPlaybackCompleted")
    }
  }

  data class PlaybackConfig(
    @Field val slug: String = "",
    @Field val token: String = ""
  ) : Record
}
