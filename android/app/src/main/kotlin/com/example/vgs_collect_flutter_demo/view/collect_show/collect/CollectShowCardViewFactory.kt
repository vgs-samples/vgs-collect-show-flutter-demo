package com.example.vgs_collect_flutter_demo.view.collect_show.collect

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory

class CollectShowCardViewFactory constructor(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?) =
        context?.let { CollectShowCardView(it, messenger, viewId) }
            ?: throw IllegalArgumentException("Context can't be null.")
}