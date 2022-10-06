package com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show

import android.content.Context
import android.util.Log
import com.verygoodsecurity.vgs_collect_flutter_demo.R
import com.verygoodsecurity.vgs_collect_flutter_demo.view.BasePlatformView
import com.verygoodsecurity.vgsshow.VGSShow
import com.verygoodsecurity.vgsshow.core.listener.VGSOnResponseListener
import com.verygoodsecurity.vgsshow.core.network.client.VGSHttpMethod
import com.verygoodsecurity.vgsshow.core.network.model.VGSResponse
import com.verygoodsecurity.vgsshow.widget.VGSTextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ShowCardView constructor(
    context: Context,
    messenger: BinaryMessenger,
    id: Int
) : BasePlatformView(VIEW_TYPE, context, messenger, id, R.layout.show_card_layout),
    VGSOnResponseListener {

    private val vgsTvPersonName: VGSTextView = rootView.findViewById(R.id.vgsTvPersonName)
    private val vgsTvCardNumber: VGSTextView = rootView.findViewById(R.id.vgsTvCardNumber)
    private val vgsTvExpiry: VGSTextView = rootView.findViewById(R.id.vgsTvExpiry)

    private var show: VGSShow? = null
    private var result: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "configureShow" -> configure(call.arguments as? Map<*, *>)
            "revealCard" -> revealCard(call.arguments as? Map<*, *>, result)
            "copyCard" -> copyCard(result)
        }
    }

    override fun dispose() {
        show?.onDestroy()
    }

    override fun onResponse(response: VGSResponse) {
        Log.d("android", "onResponse, response = $response")
        result?.success(
            mapOf(
                "STATUS" to if (response is VGSResponse.Success) "SUCCESS" else "FAILED",
                "CODE" to response.code
            )
        )
        result = null
    }

    private fun configure(arguments: Map<*, *>?) {
        show = VGSShow(
            context,
            arguments?.get("vault_id") as? String ?: "",
            arguments?.get("environment") as? String ?: ""
        )
        show?.subscribe(vgsTvPersonName)
        show?.subscribe(vgsTvCardNumber)
        show?.subscribe(vgsTvExpiry)
        show?.addOnResponseListener(this)
    }

    private fun revealCard(arguments: Map<*, *>?, result: MethodChannel.Result) {
        this.result = result
        show?.requestAsync(
            arguments?.get("path") as? String ?: "",
            VGSHttpMethod.POST,
            readPayload(arguments)
        )
    }

    private fun readPayload(arguments: Map<*, *>?): Map<String, Any> {
        val payload = arguments?.get("payload") as? Map<*, *>
        val result = mutableMapOf<String, Any>()
        payload?.forEach { (key, value) ->
            (key as? String)?.let { nunNullKey ->
                value?.let {
                    result[nunNullKey] = it
                }
            }
        }
        return result
    }

    private fun copyCard(result: MethodChannel.Result) {
        vgsTvCardNumber.copyToClipboard()
        result.success(null)
    }

    companion object {

        const val VIEW_TYPE = "show-card-form-view"
    }
}