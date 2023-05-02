package com.example.style_ml_tflite

import org.tensorflow.lite.DataType
import org.tensorflow.lite.support.common.TensorOperator;
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer

class ScalarMultiplyOp(private val factor: Float) : TensorOperator {
    override fun apply(input: TensorBuffer): TensorBuffer {
        val shape = input.shape
        val data = input.floatArray

        for (i in data.indices) {
            data[i] = this.factor * data[i]
        }

        val tensorBuffer = TensorBuffer.createFixedSize(shape, DataType.FLOAT32)
        tensorBuffer.loadArray(data, shape)

        return tensorBuffer
    }
}