package com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.collect

import android.content.Context
import android.util.Log
import android.widget.TextView
import com.verygoodsecurity.vgscollect.core.HTTPMethod
import com.verygoodsecurity.vgscollect.core.VGSCollect
import com.verygoodsecurity.vgscollect.core.model.network.VGSResponse
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.MainActivity
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.R
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.BaseFormView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class CardCollectFormView constructor(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    private val vgsCollect: VGSCollect
) : BaseFormView(context, messenger, id, R.layout.collect_form_layout) {

    override val viewType: String get() = MainActivity.COLLECT_FORM_VIEW_TYPE

    private val cardNumberAlias = rootView.findViewById<TextView>(R.id.tvCardNumberAlias)
    private val cardDateAlias = rootView.findViewById<TextView>(R.id.tvExpDateAlias)

    init {
        vgsCollect.bindView(rootView.findViewById(R.id.etCardNumber))
        vgsCollect.bindView(rootView.findViewById(R.id.etExpDate))
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "redactCard" -> redactCard(result)
        }
    }

    private fun redactCard(result: MethodChannel.Result) {
        runOnBackground {
            with(vgsCollect.submit("post", HTTPMethod.POST)) {
                runOnMain {
                    when (this) {
                        is VGSResponse.SuccessResponse -> handleSuccess(this, result)
                        is VGSResponse.ErrorResponse -> result.error(this.code.toString(), this.localizeMessage, this.body)
                    }
                }
            }
        }
    }

    private fun handleSuccess(successResponse: VGSResponse.SuccessResponse, result: MethodChannel.Result) {
        with(successResponse.body?.toJson()) {
            var cardAlias: String? = null
            var dateAlias: String? = null
            try {
                (this?.get("json") as? JSONObject)?.let {
                    cardAlias = it.get("cardNumber").toString()
                    dateAlias = it.get("expDate").toString()
                }
            } catch (e: Exception) {
                Log.d("CardCollectFormView", e.toString())
            }
            cardNumberAlias.text = cardAlias.toString()
            cardDateAlias.text = dateAlias.toString()
            result.success(mapOf(
                    "cardNumber" to cardAlias,
                    "expDate" to dateAlias,
            ))
        }
    }

    private fun String.toJson(): JSONObject? = try {
        JSONObject(this)
    } catch (e: Exception) {
        null
    }
}