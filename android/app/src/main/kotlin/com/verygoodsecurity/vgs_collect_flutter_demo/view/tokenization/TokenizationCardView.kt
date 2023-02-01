package com.verygoodsecurity.vgs_collect_flutter_demo.view.tokenization

import android.content.Context
import android.util.Log
import androidx.annotation.CallSuper
import com.google.gson.Gson
import com.verygoodsecurity.vgs_collect_flutter_demo.R
import com.verygoodsecurity.vgs_collect_flutter_demo.extensions.fromJson
import com.verygoodsecurity.vgs_collect_flutter_demo.extensions.toFormattedJson
import com.verygoodsecurity.vgs_collect_flutter_demo.view.BasePlatformView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.Scanner
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.ScannerParams
import com.verygoodsecurity.vgscollect.core.VGSCollect
import com.verygoodsecurity.vgscollect.core.VgsCollectResponseListener
import com.verygoodsecurity.vgscollect.core.model.network.VGSResponse
import com.verygoodsecurity.vgscollect.core.model.state.FieldState
import com.verygoodsecurity.vgscollect.core.storage.OnFieldStateChangeListener
import com.verygoodsecurity.vgscollect.view.InputFieldView
import com.verygoodsecurity.vgscollect.widget.CardVerificationCodeEditText
import com.verygoodsecurity.vgscollect.widget.ExpirationDateEditText
import com.verygoodsecurity.vgscollect.widget.PersonNameEditText
import com.verygoodsecurity.vgscollect.widget.VGSCardNumberEditText
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class TokenizationCardView constructor(
    private val scanner: Scanner, context: Context, messenger: BinaryMessenger, id: Int
) : BasePlatformView(VIEW_TYPE, context, messenger, id, R.layout.tokenization_layout),
    VgsCollectResponseListener {

    private var collect: VGSCollect? = null
    private var result: MethodChannel.Result? = null

    private val vgsEtPersonName: PersonNameEditText = rootView.findViewById(R.id.vgsEtPersonName)
    private val vgsEtCardNumber: VGSCardNumberEditText = rootView.findViewById(R.id.vgsEtCardNumber)
    private val vgsEtExpiry: ExpirationDateEditText = rootView.findViewById(R.id.vgsEtExpiry)
    private val vgsEtCVC: CardVerificationCodeEditText = rootView.findViewById(R.id.vgsEtCVC)

    @CallSuper
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("Test", call.method)
        when (call.method) {
            "configureCollect" -> configureCollect(call.arguments as? Map<*, *>)
            "isFormValid" -> isFormValid(result)
            "presentCardIO" -> presentCardIO()
            "showKeyboard" -> requestFocusAndShowKeyboard(vgsEtPersonName)
            "hideKeyboard" -> {
                vgsEtPersonName.hideKeyboard()
                result.success(null)
            }
            "tokenizeCard" -> tokenize(result)
        }
    }

    override fun onResponse(response: VGSResponse?) {
        val resultData = mutableMapOf<String, Any>()
        if (response is VGSResponse.SuccessResponse) {
            resultData["STATUS"] = "SUCCESS"
            resultData["DATA"] = response.body?.fromJson<HashMap<String, Any>>() ?: ""
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
        collect?.addOnFieldStateChangeListener(object : OnFieldStateChangeListener {

            override fun onStateChange(state: FieldState) {
                val states = Gson().toJson(collect?.getAllStates()).toFormattedJson()
                methodChannel.invokeMethod("stateDidChange", mapOf("STATE_DESCRIPTION" to states))
            }
        })
    }

    private fun isFormValid(result: MethodChannel.Result) {
        result.success(isPersonNameValid() && isCardNumberValid() && isExpiryValid() && isCVCValid())
    }

    private fun presentCardIO() {
        collect?.let {
            scanner.start(
                ScannerParams.CardIO(
                    vgsEtCardNumber.getFieldName() ?: "",
                    vgsEtPersonName.getFieldName() ?: "",
                    vgsEtExpiry.getFieldName() ?: "",
                    vgsEtCVC.getFieldName() ?: "",
                )
            ) { requestCode, resultCode, data ->
                collect?.onActivityResult(requestCode, resultCode, data)
                methodChannel.invokeMethod(
                    if (resultCode == Scanner.RESULT_CODE_CANCEL) "userDidCancelScan" else "userDidFinishScan",
                    null
                )
            }
        }
    }

    private fun tokenize(result: MethodChannel.Result) {
        this.result = result
        collect?.tokenize()
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

        const val VIEW_TYPE = "tokenize-card-collect-form-view"
    }
}