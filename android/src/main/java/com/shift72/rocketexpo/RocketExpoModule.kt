package com.shift72.rocketexpo

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import expo.modules.kotlin.records.Record
import expo.modules.kotlin.records.Field

import android.util.Log;

class RocketExpoModule : Module() {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('RocketExpo')` in JavaScript.
    Name("RocketExpo")

    // Defines constant property on the module.
    Constant("PI") {
      Math.PI
    }

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("hello") {
      "Hello world! 👋"
    }

    Function("setupHostname") { hostname: String ->
       RocketExpoView.hostname = hostname
    }

    Function("setupLogger") {

    }

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("setValueAsync") { value: String ->
      // Send an event to JavaScript.
      sendEvent("onChange", mapOf(
        "value" to value
      ))
    }


    // Enables the module to be used as a native view. Definition components that are accepted as part of
    // the view definition: Prop, Events.
    View(RocketExpoView::class) {
      // Defines a setter for the `url` prop.
      Prop("playback_config") { view: RocketExpoView, config: PlaybackConfig ->
        if (!config.slug.isEmpty() && !config.token.isEmpty()) {
          view.player.play(config.slug, config.token);
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
