package com.example.style_ml_tflite

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks
import com.google.android.gms.tflite.client.TfLiteInitializationOptions
import com.google.android.gms.tflite.gpu.support.TfLiteGpu
import com.google.android.gms.tflite.java.TfLite
import org.tensorflow.lite.DataType
import org.tensorflow.lite.InterpreterApi
import org.tensorflow.lite.InterpreterApi.Options.TfLiteRuntime
import org.tensorflow.lite.gpu.GpuDelegateFactory
import org.tensorflow.lite.nnapi.NnApiDelegate
import org.tensorflow.lite.support.common.FileUtil
import org.tensorflow.lite.support.common.TensorProcessor
import org.tensorflow.lite.support.common.ops.DequantizeOp
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.support.image.ops.ResizeWithCropOrPadOp
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer
import kotlin.math.min

class StyleTransfer(private val context: Context) {
    companion object {
        const val TAG = "StyleTransfer"
    }

    private lateinit var interpreterPredict: InterpreterApi
    private lateinit var interpreterTransfer: InterpreterApi
    private var nnApiDelegate: NnApiDelegate? = null

    private var inputPredictShape = intArrayOf()
    private var inputTransferShape = intArrayOf()
    private var outputPredictShape = intArrayOf()
    private var outputTransferShape = intArrayOf()

    init {
        TfLiteGpu.isGpuDelegateAvailable(context)
            .continueWith { task ->
                Log.i(TAG, "Has GPU Delegate: ${task.result}")
                task.result
            }.continueWith { task ->
                val useGpu = task.result
                val initOptions = TfLiteInitializationOptions.builder()
                    .setEnableGpuDelegateSupport(useGpu)
                    .build()

                val initTask = TfLite.initialize(context, initOptions)
                    .addOnSuccessListener {
                        loadModels(useGpu)
                    }.addOnFailureListener { e ->
                        Log.e(TAG, e.message ?: "Failed to initialize TensorFlow Lite")
                        throw e
                    }
                Tasks.await(initTask)
            }
    }

    fun transfer(styleImage: Bitmap, contentImage: Bitmap, ratio: Float = 0.5f): Bitmap {
        val style = processInputImage(styleImage, inputPredictShape[1], inputPredictShape[2])
        val content = processInputImage(contentImage, inputTransferShape[1], inputTransferShape[2])
        val contentStyle = processInputImage(contentImage, inputPredictShape[1], inputPredictShape[2])

        val stylePredictOutput = let {
            val stylePredictTensor =
                TensorBuffer.createFixedSize(outputPredictShape, DataType.FLOAT32)
            interpreterPredict.run(style.buffer, stylePredictTensor.buffer)

            val contentPredictTensor =
                TensorBuffer.createFixedSize(outputPredictShape, DataType.FLOAT32)
            interpreterPredict.run(contentStyle.buffer, contentPredictTensor.buffer)

            mixStyle(contentPredictTensor, stylePredictTensor, ratio)
        }

        val transferOutputTensor =
            TensorBuffer.createFixedSize(outputTransferShape, DataType.FLOAT32)
        interpreterTransfer.runForMultipleInputsOutputs(
            arrayOf(content.buffer, stylePredictOutput.buffer),
            mapOf(Pair(0, transferOutputTensor.buffer))
        )

        return processOutputImage(transferOutputTensor)
    }

    fun close() {
        nnApiDelegate?.close()
    }

    private fun loadModels(useGpu: Boolean) {
        val modelPredict = FileUtil.loadMappedFile(context, "style-predict-fp16.tflite")
        val modelTransfer = FileUtil.loadMappedFile(context, "style-transfer-fp16.tflite")

        val options = InterpreterApi.Options()
            .setRuntime(TfLiteRuntime.FROM_SYSTEM_ONLY)
            .setNumThreads(4)

        if (useGpu) {
            options.addDelegateFactory(GpuDelegateFactory())
        } else {
            val nnApiOptions = NnApiDelegate.Options()
                .setAllowFp16(true)
                .setExecutionPreference(NnApiDelegate.Options.EXECUTION_PREFERENCE_SUSTAINED_SPEED)

            nnApiDelegate = NnApiDelegate(nnApiOptions)
            options.addDelegate(nnApiDelegate)
        }

        interpreterPredict = InterpreterApi.create(modelPredict, options)
        interpreterTransfer = InterpreterApi.create(modelTransfer, options)

        inputPredictShape = interpreterPredict.getInputTensor(0).shape()
        outputPredictShape = interpreterPredict.getOutputTensor(0).shape()
        inputTransferShape = interpreterTransfer.getInputTensor(0).shape()
        outputTransferShape = interpreterTransfer.getOutputTensor(0).shape()
    }

    private fun processInputImage(image: Bitmap, targetWidth: Int, targetHeight: Int): TensorImage {
        val width = image.width
        val height = image.height
        val cropSize = min(width, height)

        val imageProcessor = ImageProcessor.Builder()
            .add(ResizeWithCropOrPadOp(cropSize, cropSize))
            .add(ResizeOp(targetHeight, targetWidth, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(0f, 255f))
            .build()

        val tensorImage = TensorImage(DataType.FLOAT32)
        tensorImage.load(image)

        return imageProcessor.process(tensorImage)
    }

    private fun processOutputImage(output: TensorBuffer): Bitmap {
        val imageProcessor = ImageProcessor.Builder()
            .add(DequantizeOp(0f, 255f))
            .build()

        val tensorImage = TensorImage(DataType.FLOAT32)
        tensorImage.load(output)

        return imageProcessor.process(tensorImage).bitmap
    }

    private fun mixStyle(styleA: TensorBuffer, styleB: TensorBuffer, ratio: Float): TensorBuffer {
        val processorA = TensorProcessor.Builder()
            .add(ScalarMultiplyOp(1 - ratio))
            .build()
        val processorB = TensorProcessor.Builder()
            .add(ScalarMultiplyOp(ratio))
            .build()

        val bufferA = processorA.process(styleA)
        val bufferB = processorB.process(styleB)

        val sumProcessor = TensorProcessor.Builder()
            .add(AddOp(bufferA))
            .build()

        return sumProcessor.process(bufferB)
    }
}
