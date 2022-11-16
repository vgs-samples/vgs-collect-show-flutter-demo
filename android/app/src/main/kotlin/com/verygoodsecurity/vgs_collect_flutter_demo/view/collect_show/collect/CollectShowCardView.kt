package com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect

import android.content.Context
import androidx.annotation.CallSuper
import com.verygoodsecurity.vgs_collect_flutter_demo.view.BasePlatformView
import com.google.gson.Gson
import com.verygoodsecurity.vgs_collect_flutter_demo.R
import com.verygoodsecurity.vgs_collect_flutter_demo.extensions.toFormattedJson
import com.verygoodsecurity.vgscollect.core.HTTPMethod
import com.verygoodsecurity.vgscollect.core.VGSCollect
import com.verygoodsecurity.vgscollect.core.VgsCollectResponseListener
import com.verygoodsecurity.vgscollect.core.model.network.VGSResponse
import com.verygoodsecurity.vgscollect.core.model.state.FieldState
import com.verygoodsecurity.vgscollect.core.storage.OnFieldStateChangeListener
import com.verygoodsecurity.vgscollect.view.InputFieldView
import com.verygoodsecurity.vgscollect.widget.ExpirationDateEditText
import com.verygoodsecurity.vgscollect.widget.PersonNameEditText
import com.verygoodsecurity.vgscollect.widget.VGSCardNumberEditText
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CollectShowCardView constructor(
    context: Context, messenger: BinaryMessenger, id: Int
) : BasePlatformView(VIEW_TYPE, context, messenger, id, R.layout.collect_with_show_form_layout),
    VgsCollectResponseListener {

    private var collect: VGSCollect? = null
    private var result: MethodChannel.Result? = null

    private val vgsEtPersonName: PersonNameEditText = rootView.findViewById(R.id.vgsEtPersonName)
    private val vgsEtCardNumber: VGSCardNumberEditText = rootView.findViewById(R.id.vgsEtCardNumber)
    private val vgsEtExpiry: ExpirationDateEditText = rootView.findViewById(R.id.vgsEtExpiry)

    @CallSuper
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "configureCollect" -> configureCollect(call.arguments as? Map<*, *>)
            "showKeyboard" -> requestFocusAndShowKeyboard(vgsEtPersonName)
            "hideKeyboard" -> vgsEtPersonName.hideKeyboard()
            "isFormValid" -> isFormValid(result)
            "redactCard" -> redactCard(result)
        }
    }

    override fun onResponse(response: VGSResponse?) {
        val resultData = mutableMapOf<String, Any>()
        if (response is VGSResponse.SuccessResponse) {
            resultData["STATUS"] = "SUCCESS"
            resultData["DATA"] = Gson().fromJson(response.body, HashMap::class.java)
        } else {
            resultData["STATUS"] = "FAILED"
        }
        result?.success(resultData)
        result = null
    }

    private fun configureCollect(arguments: Map<*, *>?) {
        collect = VGSCollect(
            context,
            arguments?.get("vault_id") as? String ?: "",
            arguments?.get("environment") as? String ?: ""
        )
        collect?.addOnResponseListeners(this)
        collect?.bindView(vgsEtPersonName, vgsEtCardNumber, vgsEtExpiry)
        collect?.addOnFieldStateChangeListener(object : OnFieldStateChangeListener {

            override fun onStateChange(state: FieldState) {
                val states = Gson().toJson(collect?.getAllStates()).toFormattedJson()
                methodChannel.invokeMethod("stateDidChange", mapOf("STATE_DESCRIPTION" to states))
            }
        })
    }

    private fun isFormValid(result: MethodChannel.Result) {
        result.success(isPersonNameValid() && isCardNumberValid() && isExpiryValid())
    }

    private fun redactCard(result: MethodChannel.Result) {
        this.result = result
        collect?.asyncSubmit("/post", HTTPMethod.POST)
    }

    override fun dispose() {
        collect?.onDestroy()
    }

    private fun isPersonNameValid() = vgsEtPersonName.getState()?.isValid == true

    private fun isCardNumberValid() = vgsEtCardNumber.getState()?.isValid == true

    private fun isExpiryValid() = vgsEtExpiry.getState()?.isValid == true

    private fun requestFocusAndShowKeyboard(inputView: InputFieldView) {
        inputView.requestFocus()
        inputView.showKeyboard()
    }

    companion object {

        const val VIEW_TYPE = "card-collect-for-show-form-view"
    }
}