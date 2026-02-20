import ExpoModulesCore
import Shift72RocketSDK

public class RocketExpoModule: Module {
  static var loggerDelegate: RocketExpoLoggerDelegate {
    RocketExpoLoggerDelegate()
  }

  public func definition() -> ModuleDefinition {
    Name("RocketExpo")

    Events(RocketExpoEventsDelegate.EventList)

    Function("setupHostname") { (hostname: String) in
        RocketExpoView.hostname = hostname
    }

    Function("setupLogger") { (prefix: String) in
        RocketExpoModule.loggerDelegate.prefix = prefix
        Shift72RocketSDK.Logger.setDelegate(RocketExpoModule.loggerDelegate)
    }

    Function("openPlayerFullscreen") { (config: PlaybackConfig) in
        DispatchQueue.main.async {
            guard let appContext = self.appContext else {
                RocketExpoModule.loggerDelegate.error(message: "\(String(describing: Self.self)) Failed to open fullscreen player, appContext nil")
                return
            }
            let eventDelegate = RocketExpoEventsDelegate(appContext: appContext)
            let player = RocketExpoPlayerViewController.init(hostname: RocketExpoView.hostname, slug: config.slug, token: config.token, eventDelegate: eventDelegate)
            player.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            UIApplication.shared.delegate?.window??.rootViewController?.present(player, animated: true)
        }
    }

    View(RocketExpoView.self) {
      Prop("playbackConfig") { (view: RocketExpoView, config: PlaybackConfig) in
        if (!config.slug.isEmpty && !config.token.isEmpty) {
          view.player!.play(slug: config.slug, token: config.token) { maybeError in
            switch maybeError {
              case .none:
                RocketExpoModule.loggerDelegate.info(message: "\(String(describing: Self.self)) playback started")
                break
              case let .some(error):
                RocketExpoModule.loggerDelegate.error(message: "\(String(describing: Self.self)) error starting playback \(error.type): \(error.message)")
                break
            }
          }
        }
      }
    }
  }

  struct PlaybackConfig: Record {
    @Field
    var slug: String = ""

    @Field
    var token: String = ""
  }
}
