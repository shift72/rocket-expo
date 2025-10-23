import ExpoModulesCore
import Shift72RocketSDK

public class RocketExpoModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('RocketExpo')` in JavaScript.
    Name("RocketExpo")

    // Defines constant property on the module.
    Constant("PI") {
      Double.pi
    }

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("hello") {
      return "Hello world! 👋"
    }

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("setValueAsync") { (value: String) in
      // Send an event to JavaScript.
      self.sendEvent("onChange", [
        "value": value
      ])
    }

    Function("setupLogger") {
      Shift72RocketSDK.Logger.setDelegate(ExampleLoggerDelegate())
    }

    // Enables the module to be used as a native view. Definition components that are accepted as part of the
    // view definition: Prop, Events.
    View(RocketExpoView.self) {
      Prop("playback_config") { (view: RocketExpoView, config: PlaybackConfig) in
        if (!config.slug.isEmpty && !config.token.isEmpty) {
          view.player!.play(slug: config.slug, token: config.token) { maybeError in
            switch maybeError {
              case .none:
                print("started")
                break
              case let .some(error):
                print("error", error.type, error.message)
                break
            }
          }
        }
      }

      Events("onPlaybackCompleted")
    }
  }

  struct PlaybackConfig: Record {
    @Field
    var slug: String = ""
    
    @Field
    var token: String = ""
  }
}
