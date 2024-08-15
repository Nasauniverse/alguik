package com.example.alguik

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "com.example.alguik/locktask"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLockTask" -> {
                    startLockTask()
                    result.success(null)
                }
                "stopLockTask" -> {
                    stopLockTask()
                    moveTaskToBack(true)        
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

}
