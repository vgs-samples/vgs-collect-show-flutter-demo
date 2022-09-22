package com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.collect

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import com.verygoodsecurity.vgscollect.core.VGSCollect

class CardCollectViewFactory constructor(
    private val messenger: BinaryMessenger,
    private val collect: VGSCollect,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        if (context == null) {
            throw IllegalArgumentException("Context can't be null.")
        }
        return CardCollectFormView(context, messenger, viewId, collect)
    }
}