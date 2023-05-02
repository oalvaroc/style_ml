package com.example.style_ml_tflite

import org.tensorflow.lite.DataType
import org.tensorflow.lite.support.common.TensorOperator
import org.tensorflow.lite.support.common.internal.SupportPreconditions
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer
import kotlin.math.min

class AddOp(private val tensorBuffer: TensorBuffer) : TensorOperator {
    override fun apply(input: TensorBuffer): TensorBuffer {
        SupportPreconditions.checkArgument(input.shape.contentEquals(this.tensorBuffer.shape))

        val bufferA = input.floatArray
        val bufferB = this.tensorBuffer.floatArray
        val output = FloatArray(bufferA.size)

        for (i in bufferA.indices) {
            output[i] = bufferA[i] + bufferB[i]
        }

        val outputTensor = TensorBuffer.createFixedSize(input.shape, DataType.FLOAT32)
        outputTensor.loadArray(output, input.shape)

        return outputTensor
    }

}