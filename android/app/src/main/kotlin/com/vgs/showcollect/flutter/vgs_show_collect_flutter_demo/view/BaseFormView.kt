package com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view

import android.content.Context
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import androidx.annotation.LayoutRes
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Future

@Suppress("LeakingThis")
abstract class BaseFormView constructor(context: Context, messenger: BinaryMessenger, id: Int, @LayoutRes layoutId: Int) :
        PlatformView, MethodChannel.MethodCallHandler {

    abstract val viewType: String

    protected val rootView: View = LayoutInflater.from(context).inflate(layoutId, null)

    protected val methodChannel = MethodChannel(messenger, "$viewType/$id".also {
        Log.d("Test", it)
    })

    private val mainHandler: android.os.Handler = android.os.Handler(Looper.getMainLooper())

    private val submittedTasks = mutableListOf<Future<*>>()

    private val executor: ExecutorService by lazy {
        Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors())
    }

    init {

        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View = rootView

    override fun dispose() {
        cancelAllTasks()
    }

    protected fun runOnBackground(action: () -> Unit) {
        submittedTasks.add(executor.submit {
            action.invoke()
        })
    }

    protected fun runOnMain(action: () -> Unit) {
        mainHandler.post { action.invoke() }
    }

    private fun cancelAllTasks() {
        submittedTasks.forEach {
            it.cancel(true)
        }
        submittedTasks.clear()
    }
}