package com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.collect

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class CardCollectViewFactory constructor(private val messenger: BinaryMessenger? = null) :
        PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return CardCollectFormView(context, messenger, id)
    }
}