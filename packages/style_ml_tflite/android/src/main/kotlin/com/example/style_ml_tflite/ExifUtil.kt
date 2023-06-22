package com.example.style_ml_tflite

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import androidx.exifinterface.media.ExifInterface;
import java.io.ByteArrayInputStream

class ExifUtil {
    companion object {
        fun getOrientation(image: ByteArray): Int {
            val exif = ExifInterface(ByteArrayInputStream(image))
            return exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_NORMAL
            )
        }

        fun fixImage(image: Bitmap, orientation: Int): Bitmap {
            if (orientation == ExifInterface.ORIENTATION_NORMAL) {
                return image
            }

            val transform = Matrix()
            when (orientation) {
                ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> {
                    transform.setScale(-1f, 1f)
                }

                ExifInterface.ORIENTATION_FLIP_VERTICAL -> {
                    transform.setScale(1f, -1f)
                }

                ExifInterface.ORIENTATION_ROTATE_90 -> {
                    transform.setRotate(90f)
                }

                ExifInterface.ORIENTATION_ROTATE_180 -> {
                    transform.setRotate(180f)
                }

                ExifInterface.ORIENTATION_ROTATE_270 -> {
                    transform.setRotate(270f)
                }

                ExifInterface.ORIENTATION_TRANSPOSE -> {
                    transform.setScale(-1f, 1f)
                    transform.preRotate(270f)
                }

                ExifInterface.ORIENTATION_TRANSVERSE -> {
                    transform.setScale(-1f, 1f)
                    transform.preRotate(90f)
                }
            }

            return Bitmap.createBitmap(
                image,
                0,
                0,
                image.width,
                image.height,
                transform,
                true
            )
        }
    }
}