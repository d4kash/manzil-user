package com.drs.manzil
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterFragmentActivity() {
   override fun configureFlutterEngine( flutterEngine: 
     FlutterEngine) {
     GeneratedPluginRegistrant.registerWith(flutterEngine)
     
   }
}
