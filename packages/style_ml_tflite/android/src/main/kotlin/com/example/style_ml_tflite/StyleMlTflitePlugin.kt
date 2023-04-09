package com.example.style_ml_tflite

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMethodCodec
import java.io.ByteArrayOutputStream

/** StyleMlTflitePlugin */
class StyleMlTflitePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var styleTranfer: StyleTransfer

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val taskQueue = flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "style_ml_tflite", StandardMethodCodec.INSTANCE, taskQueue)
        channel.setMethodCallHandler(this)

        styleTranfer = StyleTransfer(flutterPluginBinding.applicationContext, flutterPluginBinding.flutterAssets)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "transfer" -> {
                val styleImage = call.argument<ByteArray>("styleImage").let { bytes ->
                    BitmapFactory.decodeByteArray(bytes, 0, bytes!!.size)
                }
                val contentImage = call.argument<ByteArray>("contentImage").let { bytes ->
                    BitmapFactory.decodeByteArray(bytes, 0, bytes!!.size)
                }
                styleTranfer.transfer(styleImage, contentImage).let { output ->
                    val byteStream = ByteArrayOutputStream()
                    output.compress(Bitmap.CompressFormat.JPEG, 100, byteStream)
                    result.success(byteStream.toByteArray())
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
