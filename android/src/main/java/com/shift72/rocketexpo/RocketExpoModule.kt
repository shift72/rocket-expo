package com.shift72.rocketexpo

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import expo.modules.kotlin.records.Record
import expo.modules.kotlin.records.Field

import android.util.Log

import com.shift72.rocketexpo.RocketExpoLogger

class RocketExpoModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("RocketExpo")

    Function("setupHostname") { hostname: String ->
      RocketExpoView.hostname = hostname
    }

    Function("setupLogger") {
      RocketExpoView.playerLogger = RocketExpoLogger(appContext, "RocketPlayer")
    }

    // Enables the module to be used as a native view. Definition components that are accepted as part of
    // the view definition: Prop, Events.
    View(RocketExpoView::class) {
      // Defines a setter for the `url` prop.
      Prop("playbackConfig") { view: RocketExpoView, config: PlaybackConfig ->
        if (!config.slug.isEmpty() && !config.token.isEmpty()) {
          view.player?.play(config.slug, config.token);
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
