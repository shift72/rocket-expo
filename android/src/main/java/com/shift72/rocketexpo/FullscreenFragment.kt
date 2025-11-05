package com.shift72.rocketexpo

import android.content.pm.ActivityInfo
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.fragment.app.Fragment
import com.shift72.mobile.rocketsdk.player.RocketSurface
import com.shift72.mobile.rocketsdk.player.RocketPlayer
import com.shift72.mobile.rocketsdk.launchpad.RocketPlayerLaunchpadBase

class FullscreenFragment : Fragment() {
  private lateinit var surface: RocketSurface
  private var player: RocketPlayer? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // Lock orientation to landscape while this fragment is active
    requireActivity().requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
  }

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View {
    val frame = FrameLayout(requireContext())
    frame.layoutParams = FrameLayout.LayoutParams(
      ViewGroup.LayoutParams.MATCH_PARENT,
      ViewGroup.LayoutParams.MATCH_PARENT
    )
    frame.setBackgroundColor(Color.BLACK)

    surface = RocketSurface(requireContext()).apply {
      layoutParams = FrameLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT
      )
      setBackgroundColor(Color.BLACK)
      showController()
    }

    frame.addView(surface)
    return frame
  }

  override fun onResume() {
    super.onResume()
    enterImmersiveMode()
  }

  override fun onPause() {
    exitImmersiveMode()
    super.onPause()
  }

  private fun enterImmersiveMode() {
    val window = requireActivity().window
    WindowCompat.setDecorFitsSystemWindows(window, false)
    val controller = WindowInsetsControllerCompat(window, window.decorView)
    controller.hide(WindowInsetsCompat.Type.systemBars())
    controller.systemBarsBehavior =
      WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
    window.statusBarColor = Color.BLACK
    window.navigationBarColor = Color.BLACK
  }

  private fun exitImmersiveMode() {
    val window = requireActivity().window
    WindowCompat.setDecorFitsSystemWindows(window, true)
    WindowInsetsControllerCompat(window, window.decorView)
      .show(WindowInsetsCompat.Type.systemBars())
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    val slug = requireActivity().intent.getStringExtra("slug")
    val token = requireActivity().intent.getStringExtra("token")
    val hostname = RocketExpoView.hostname

    if (slug.isNullOrEmpty() || token.isNullOrEmpty() || hostname.isEmpty()) {
      android.util.Log.w("FullscreenFragment", "Missing slug/token/hostname; cannot start playback")
      return
    }

    player = RocketPlayerLaunchpadBase
      .MakeRocketPlayerLaunchpad(requireContext(), surface)
      .setBaseUrl(hostname)
      .setRocketPlayerListener(RocketExpoView.playerLogger)
      .setRocketOnCompleteCallback(this::onRocketComplete)
      .build()

    player?.play(slug, token)
  }

  private fun onRocketComplete() {
    android.util.Log.d("FullscreenFragment", "Playback complete")
//    ((ScreenActivity)getActivity()).sendEvent("PLAYBACK COMPLEATE")

//    val act = getActivity() as ScreenActivity
//    act.sendEvent("PLAYBACK COMPLEATE")

    // Optionally close the screen when complete:

    val act = getActivity()

    act?.let {
      it.finish()
    }

    // requireActivity().finish()
  }

  override fun onDestroyView() {
    player?.destroy()
    player = null
    super.onDestroyView()
  }

  override fun onDestroy() {
    // Restore orientation when leaving this fragment
    requireActivity().requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
    super.onDestroy()
  }
}
