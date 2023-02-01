package com.verygoodsecurity.vgs_collect_flutter_demo.view.collect

import android.content.Context
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.Scanner
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory

class CollectCardViewFactory constructor(
    private val scanner: Scanner,
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?) =
        context?.let { CollectCardView(scanner, it, messenger, viewId) }
            ?: throw IllegalArgumentException("Context can't be null.")
}