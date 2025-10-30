import ExpoModulesCore
import Shift72RocketSDK

public class RocketExpoModule: Module {
  public func definition() -> ModuleDefinition {
    Name("RocketExpo")

    Function("setupHostname") { (hostname: String) in
        RocketExpoView.hostname = hostname
    }

    Function("setupLogger") { (prefix: String) in
        if let appContext {
            Shift72RocketSDK.Logger.setDelegate(RocketExpoLoggerDelegate(appContext: appContext, prefix: prefix))
        } else {
            print("Couldn't set up RocketSDK Logger, appContext nil")
        }
    }

    View(RocketExpoView.self) {
      Prop("playbackConfig") { (view: RocketExpoView, config: PlaybackConfig) in
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
