package com.verygoodsecurity.vgs_collect_flutter_demo.view.tokenization

import android.content.Context
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.CardIO
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory

class TokenizationCardViewFactory constructor(
    private val cardIO: CardIO,
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?) =
        context?.let { TokenizationCardView(cardIO, it, messenger, viewId) }
            ?: throw IllegalArgumentException("Context can't be null.")
}