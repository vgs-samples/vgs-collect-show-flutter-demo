package com.example.vgs_collect_flutter_demo.view.collect

import android.content.Context
import androidx.annotation.CallSuper
import com.example.vgs_collect_flutter_demo.R
import com.example.vgs_collect_flutter_demo.view.BasePlatformView
import com.google.gson.Gson
import com.verygoodsecurity.vgscollect.core.HTTPMethod
import com.verygoodsecurity.vgscollect.core.VGSCollect
import com.verygoodsecurity.vgscollect.core.VgsCollectResponseListener
import com.verygoodsecurity.vgscollect.core.model.network.VGSResponse
import com.verygoodsecurity.vgscollect.view.InputFieldView
import com.verygoodsecurity.vgscollect.widget.CardVerificationCodeEditText
import com.verygoodsecurity.vgscollect.widget.ExpirationDateEditText
import com.verygoodsecurity.vgscollect.widget.PersonNameEditText
import com.verygoodsecurity.vgscollect.widget.VGSCardNumberEditText
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CollectCardView constructor(
    private val cardIO: CardIO, context: Context, messenger: BinaryMessenger, id: Int
) : BasePlatformView(VIEW_TYPE, context, messenger, id, R.layout.collect_form_layout),
    VgsCollectResponseListener {

    private var collect: VGSCollect? = null
    private var result: MethodChannel.Result? = null

    private val vgsEtPersonName: PersonNameEditText = rootView.findViewById(R.id.vgsEtPersonName)
    private val vgsEtCardNumber: VGSCardNumberEditText = rootView.findViewById(R.id.vgsEtCardNumber)
    private val vgsEtExpiry: ExpirationDateEditText = rootView.findViewById(R.id.vgsEtExpiry)
    private val vgsEtCVC: CardVerificationCodeEditText = rootView.findViewById(R.id.vgsEtCVC)

    @CallSuper
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "configureCollect" -> configureCollect(call.arguments as? Map<*, *>)
            "showKeyboard" -> requestFocusAndShowKeyboard(vgsEtPersonName)
            "hideKeyboard" -> vgsEtPersonName.hideKeyboard()
            "isFormValid" -> isFormValid(result)
            "presentCardIO" -> presentCardIO()
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
        collect?.bindView(vgsEtPersonName, vgsEtCardNumber, vgsEtExpiry, vgsEtCVC)
    }

    private fun isFormValid(result: MethodChannel.Result) {
        result.success(isPersonNameValid() && isCardNumberValid() && isExpiryValid() && isCVCValid())
    }

    private fun presentCardIO() {
        collect?.let {
            cardIO.start(
                vgsEtCardNumber.getFieldName() ?: "",
                vgsEtPersonName.getFieldName() ?: "",
                vgsEtExpiry.getFieldName() ?: "",
                vgsEtCVC.getFieldName() ?: "",
            ) { requestCode, resultCode, data ->
                collect?.onActivityResult(requestCode, resultCode, data)
                methodChannel.invokeMethod(
                    if (resultCode == CardIO.RESULT_CODE_CANCEL) "userDidCancelScan" else "userDidFinishScan",
                    null
                )
            }
        }
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

    private fun isCVCValid() = vgsEtCVC.getState()?.isValid == true

    private fun requestFocusAndShowKeyboard(inputView: InputFieldView) {
        inputView.requestFocus()
        inputView.showKeyboard()
    }

    companion object {

        const val VIEW_TYPE = "card-collect-form-view"
    }
}