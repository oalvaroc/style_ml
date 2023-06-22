package com.example.style_ml_tflite

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.SystemClock
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
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
    private lateinit var styleTransfer: StyleTransfer

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val taskQueue = flutterPluginBinding.binaryMessenger
            .makeBackgroundTaskQueue()

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "style_ml_tflite", StandardMethodCodec.INSTANCE, taskQueue)
        channel.setMethodCallHandler(this)

        styleTransfer = StyleTransfer(flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "transfer" -> {
                val start = SystemClock.uptimeMillis()

                val styleImage = call.argument<ByteArray>("styleImage").let { bytes ->
                    BitmapFactory.decodeByteArray(bytes, 0, bytes!!.size)
                }
                val contentBytes = call.argument<ByteArray>("contentImage")
                val orientation = ExifUtil.getOrientation(contentBytes!!)
                val contentImage = BitmapFactory.decodeByteArray(contentBytes, 0, contentBytes.size)
                val ratio = call.argument<Double>("ratio")

                styleTransfer.transfer(styleImage, contentImage, ratio!!.toFloat()).let { output ->
                    val byteStream = ByteArrayOutputStream()
                    val fixed = ExifUtil.fixImage(output, orientation)
                    fixed.compress(Bitmap.CompressFormat.JPEG, 100, byteStream)
                    result.success(byteStream.toByteArray())
                }

                Log.i(TAG, "Elapsed time: ${SystemClock.uptimeMillis() - start}")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        styleTransfer.close()
    }

    companion object {
        const val TAG = "StyleMlTflitePlugin"
    }
}
