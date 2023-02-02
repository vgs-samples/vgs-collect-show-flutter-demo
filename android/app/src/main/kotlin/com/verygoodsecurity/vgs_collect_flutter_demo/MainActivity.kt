package com.verygoodsecurity.vgs_collect_flutter_demo

import android.content.Intent
import com.microblink.blinkcard.MicroblinkSDK
import com.verygoodsecurity.api.blinkcard.VGSBlinkCardIntentBuilder
import com.verygoodsecurity.api.cardio.ScanActivity
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CollectCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CollectCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect.CollectShowCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect.CollectShowCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show.ShowCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show.ShowCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.Scanner
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.ScannerParams
import com.verygoodsecurity.vgs_collect_flutter_demo.view.tokenization.TokenizationCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.tokenization.TokenizationCardViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity(), Scanner {

    private var onResult: ((requestCode: Int, resultCode: Int, data: Intent?) -> Unit)? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val registry = flutterEngine.platformViewsController.registry
        registry.registerViewFactory(
            CollectCardView.VIEW_TYPE,
            CollectCardViewFactory(this, flutterEngine.dartExecutor.binaryMessenger)
        )
        registry.registerViewFactory(
            CollectShowCardView.VIEW_TYPE,
            CollectShowCardViewFactory(flutterEngine.dartExecutor.binaryMessenger)
        )
        registry.registerViewFactory(
            ShowCardView.VIEW_TYPE, ShowCardViewFactory(flutterEngine.dartExecutor.binaryMessenger)
        )
        registry.registerViewFactory(
            TokenizationCardView.VIEW_TYPE,
            TokenizationCardViewFactory(this, flutterEngine.dartExecutor.binaryMessenger)
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        onResult?.invoke(requestCode, resultCode, data)
        onResult = null
    }

    override fun start(
        params: ScannerParams,
        onResult: (requestCode: Int, resultCode: Int, data: Intent?) -> Unit
    ) {
        this.onResult = onResult
        when(params) {
            is ScannerParams.Blinkcard -> startBlinkcard(params)
            is ScannerParams.CardIO -> startCardIO(params)
        }
    }

    private fun startBlinkcard(params: ScannerParams.Blinkcard) {
        MicroblinkSDK.setLicenseKey(params.licenseKey, applicationContext)
        val intent = VGSBlinkCardIntentBuilder(this.activity)
            .setCardHolderFieldName(params.cardHolderNameFieldName)
            .setCardNumberFieldName(params.cardNumberFieldName)
            .setExpirationDateFieldName(params.expiryFieldName)
            .setCVCFieldName(params.cvcFieldName)
            .build()
        startActivityForResult(intent, 1)
    }

    private fun startCardIO(params: ScannerParams.CardIO) {
        val intent = Intent(this, ScanActivity::class.java)
        intent.putExtra(ScanActivity.SCAN_CONFIGURATION, hashMapOf<String?, Int>().apply {
            this[params.cardNumberFieldName] = ScanActivity.CARD_HOLDER
            this[params.cardNumberFieldName] = ScanActivity.CARD_NUMBER
            this[params.expiryFieldName] = ScanActivity.CARD_EXP_DATE
            this[params.cvcFieldName] = ScanActivity.CARD_CVC
        })
        startActivityForResult(intent, 1)
    }
}
