package com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.reveal

import android.content.Context
import com.verygoodsecurity.vgsshow.VGSShow
import com.verygoodsecurity.vgsshow.core.network.client.VGSHttpMethod
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.MainActivity
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.R
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.BaseFormView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CardShowFormView constructor(context: Context, messenger: BinaryMessenger?, id: Int) :
        BaseFormView(context, messenger, id, R.layout.show_form_layout) {

    override val viewType: String get() = MainActivity.SHOW_FORM_VIEW_TYPE

    private val vgsShow = VGSShow(context, MainActivity.VAULT_ID, MainActivity.ENVIRONMENT)

    init {

        vgsShow.subscribe(rootView.findViewById(R.id.tvCardNumber))
        vgsShow.subscribe(rootView.findViewById(R.id.tvCardExpiration))
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "revealCard" -> revealCard(call)
        }
    }

    private fun revealCard(call: MethodCall) {
        val data = call.arguments as ArrayList<*>
        runOnBackground {
            vgsShow.request("post", VGSHttpMethod.POST, mapOf(
                    "payment_card_number" to data[0],
                    "payment_card_expiration_date" to data[1]
            ))
        }
    }
}