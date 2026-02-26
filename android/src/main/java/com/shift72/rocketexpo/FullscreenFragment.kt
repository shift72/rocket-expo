package com.shift72.rocketexpo

import android.content.pm.ActivityInfo
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.ImageButton
import android.util.TypedValue
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
  private var uiVisible: Boolean = false

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
  }

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View {
    val frame = RelativeLayout(requireContext())
    frame.layoutParams = RelativeLayout.LayoutParams(
      ViewGroup.LayoutParams.MATCH_PARENT,
      ViewGroup.LayoutParams.MATCH_PARENT
    )
    frame.setBackgroundColor(Color.BLACK)

    val closeButton = ImageButton(requireContext()).apply {
      layoutParams = RelativeLayout.LayoutParams(
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 45f, resources.displayMetrics).toInt(),
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 55f, resources.displayMetrics).toInt()
      )
      scaleType = ImageView.ScaleType.FIT_XY
      setImageResource(com.google.android.exoplayer2.ui.R.drawable.exo_ic_chevron_left)
      setBackgroundColor(Color.TRANSPARENT)
      setOnClickListener {
        RocketExpoModule.mod?.get()?.sendEvent("onUserPlaybackAborted", emptyMap())
        onRocketComplete()
      }
    }

    surface = RocketSurface(requireContext()).apply {
      layoutParams = FrameLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT
      )
      setControllerVisibilityListener(object : com.google.android.exoplayer2.ui.StyledPlayerView.ControllerVisibilityListener {
        override fun onVisibilityChanged(visibility: Int) {
            if (visibility == com.google.android.exoplayer2.ui.StyledPlayerView.GONE && uiVisible){
              uiVisible = false
              android.util.Log.d("TAG", "This UI is Hidden")
              closeButton.setVisibility(View.GONE)
            }
            if (visibility == com.google.android.exoplayer2.ui.StyledPlayerView.VISIBLE && !uiVisible){
              uiVisible = true
              android.util.Log.d("TAG", "This UI is Showen")
              closeButton.setVisibility(View.VISIBLE)
            }
        }
      })
      setBackgroundColor(Color.BLACK)
      showController()
    }

    frame.addView(surface)


    frame.addView(closeButton)
    return frame
  }

  override fun onStart() {

    super.onStart()
    val slug = requireActivity().intent.getStringExtra("slug")
    val token = requireActivity().intent.getStringExtra("token")
    player?.also { player ->
      player.play(slug, token)
    }
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
    RocketExpoModule.mod?.get()?.sendEvent("onFullscreenEnter", emptyMap())

  }

  private fun exitImmersiveMode() {
    val window = requireActivity().window
    WindowCompat.setDecorFitsSystemWindows(window, true)
    WindowInsetsControllerCompat(window, window.decorView)
      .show(WindowInsetsCompat.Type.systemBars())
    RocketExpoModule.mod?.get()?.sendEvent("onFullscreenExit", emptyMap())
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    val hostname = RocketExpoView.hostname

    val slug = requireActivity().intent.getStringExtra("slug")
    val token = requireActivity().intent.getStringExtra("token")

    if (slug.isNullOrEmpty() || token.isNullOrEmpty() || hostname.isEmpty()) {
      android.util.Log.w("FullscreenFragment", "Missing slug/token/hostname; cannot start playback")
      return
    }

    player = RocketPlayerLaunchpadBase
      .MakeRocketPlayerLaunchpad(getActivity(), surface)
      .setBaseUrl(hostname)
      .setRocketPlayerListener(RocketExpoView.playerLogger)
      .setRocketDelegate(ExpoRocketDelegate(requireContext(), RocketExpoModule.mod!!, this::onRocketComplete))
      .build()


  }

  private fun onRocketComplete() {
    android.util.Log.d("FullscreenFragment", "Playback complete")

    val act = getActivity()

    act?.let {
      it.finish()
    }
  }

  override fun onDestroyView() {
    player?.destroy()
    player = null
    super.onDestroyView()
  }

  override fun onDestroy() {
    // Restore orientation when leaving this fragment
    super.onDestroy()
  }
}
