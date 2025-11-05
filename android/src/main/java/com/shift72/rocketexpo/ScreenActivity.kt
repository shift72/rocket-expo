package com.shift72.rocketexpo

import android.os.Bundle
import androidx.fragment.app.FragmentActivity

class ScreenActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null) {
            supportFragmentManager
                .beginTransaction()
                .replace(android.R.id.content, FullscreenFragment())
                .commit()
        }
    }

    fun sendEvent(event: String){
//            val params = Arguments.createMap();
//            params.putString("message", event);
//            val reactContext = this.getReactActivityDelegate().getReactHost().getCurrentReactContext();
//
//            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
//                .emit("myCustomEvent", params);
    }

}
