package com.verygoodsecurity.vgs_collect_flutter_demo.view

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import androidx.annotation.LayoutRes
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

abstract class BasePlatformView constructor(
    viewType: String,
    protected val context: Context,
    messenger: BinaryMessenger,
    id: Int,
    @LayoutRes layoutId: Int
) : PlatformView, MethodChannel.MethodCallHandler {

    protected val rootView: View = LayoutInflater.from(context).inflate(layoutId, null)

    protected val methodChannel = MethodChannel(messenger, "$viewType/$id")

    init {

        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View = rootView
}