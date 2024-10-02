package com.verygoodsecurity.vgs_collect_flutter_demo

import android.content.Intent
import com.microblink.blinkcard.MicroblinkSDK
import com.verygoodsecurity.api.blinkcard.VGSBlinkCardIntentBuilder
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CollectCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CollectCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect.CollectShowCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect.CollectShowCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show.ShowCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show.ShowCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.core.Scanner
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
        cardNumberFieldName: String,
        cardHolderNameFieldName: String,
        expiryFieldName: String,
        cvcFieldName: String,
        licenseKey: String,
        onResult: (requestCode: Int, resultCode: Int, data: Intent?) -> Unit
    ) {
        this.onResult = onResult
        MicroblinkSDK.setLicenseKey(licenseKey, applicationContext)
        val intent = VGSBlinkCardIntentBuilder(this.activity)
            .setCardHolderFieldName(cardHolderNameFieldName)
            .setCardNumberFieldName(cardNumberFieldName)
            .setExpirationDateFieldName(expiryFieldName)
            .setCVCFieldName(cvcFieldName)
            .build()
        startActivityForResult(intent, 1)
    }
}
