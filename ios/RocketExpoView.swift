import ExpoModulesCore
import AVKit
import SwiftUI
import AVFoundation
import Shift72RocketSDK

class RocketExpoView: ExpoView {
    let player = AVPlayer()
    let delegate = MyRocketPlayerDelegate()

    let hostingController = UIHostingController(rootView: PlayerView())

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)
    }

}

struct PlayerView: View {
    let delegate = MyRocketPlayerDelegate()
    let player = AVPlayer()
    let token = ""
    let slug = ""
    let hostname = ""

    var body: some View {
        MyViewControllerRepresentable(player: self.player)
            .onAppear {
                let rp = RocketPlayer.init(player: self.player, hostname: self.hostname, delegate: self.delegate)
                rp.play(slug: self.slug, token: self.token) { maybeError in
                    switch maybeError {
                    case .none:
                        print("playback initialised")
                    case let .some(error):
                        print("playback error, \(error.type) \(error.message)")
                    }
                }
            }
            .ignoresSafeArea(.all)
    }
}


struct MyViewControllerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer

    init(player: AVPlayer) {
        self.player = player
    }

    func makeUIViewController(context: Context) -> MyPresenter {
        let container = MyPresenter()
        container.onAppear = { presenter in
            let controller = AVPlayerViewController()
            controller.entersFullScreenWhenPlaybackBegins = true
            controller.videoGravity = .resizeAspect
            controller.modalPresentationStyle = .fullScreen
            // You may wish to attach an AVPlayerViewControllerDelegate here to respond to some events, e.g. picture-in-picture start/end
            presenter.present(controller, animated: true)
        }
        return container
    }

    func updateUIViewController(_ uiViewController: MyPresenter, context: Context) {
    }
}

class MyPresenter: UIViewController {
    var onAppear: ((MyPresenter) -> Void)?

    override func viewDidAppear(_ animated: Bool) {
        if let onAppear {
            onAppear(self)
            self.onAppear = nil
        }
    }
}

struct MyRocketPlayerDelegate: RocketPlayerDelegate{
  func onWatchWindow(timeToWatch: Int, response: @escaping (Shift72RocketSDK.WatchWindowResponse) -> Void) {
      print("player delegate onWatchWindow \(timeToWatch)")
      response(.StartWatchWindow)
  }

  func onFoundPlaybackProgress(position: Int, length: Int, response: @escaping (Shift72RocketSDK.PlaybackProgressResponse) -> Void) {
      print("player delegate onFoundPlaybackProgress \(position)/\(length)")
      response(.StartFromBeginning)
  }

  func onTooManyDevicesPlaybackAborted() {
      print("player delegate onTooManyDevicesPlaybackAborted")
  }

  func onTooManyConcurrentStreamsPlaybackAborted() {
      print("player delegate onTooManyConcurrentStreamsPlaybackAborted")
  }

  func onPlaybackStarted() {
      print("player delegate onPlaybackStarted")
  }

  func onPlaybackCompleted() {
      print("player delegate onPlaybackCompleted")
  }

  func onErrorPlaybackAborted() {
      print("player delegate onErrorPlaybackAborted")
  }

  func onAuthorizationErrorPlaybackAborted() {
      print("player delegate onAuthorizationErrorPlaybackAborted")
  }

  func videoSizeChanged(width: Double, height: Double) {
      print("player delegate videoSizeChanged \(width)x\(height)")
  }
}

