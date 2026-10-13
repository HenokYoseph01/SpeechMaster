package com.example.speech_coach

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "speech_coach/permissions")
            .setMethodCallHandler { call, result ->
                if (call.method == "openAppSettings") {
                    try {
                        startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                            data = Uri.fromParts("package", packageName, null)
                        })
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("settings_unavailable", error.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
