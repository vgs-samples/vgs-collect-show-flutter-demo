package com.verygoodsecurity.vgs_collect_flutter_demo

import android.content.Intent
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CardIO
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CollectCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect.CollectCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect.CollectShowCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.collect.CollectShowCardViewFactory
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show.ShowCardView
import com.verygoodsecurity.vgs_collect_flutter_demo.view.collect_show.show.ShowCardViewFactory
import com.verygoodsecurity.api.cardio.ScanActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity(), CardIO {

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
            ShowCardView.VIEW_TYPE,
            ShowCardViewFactory(flutterEngine.dartExecutor.binaryMessenger)
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        onResult?.invoke(requestCode, resultCode, data)
        onResult = null
    }

    override fun start(
        cardNumber: String,
        cardHolderName: String,
        expiry: String,
        cvc: String,
        onResult: (requestCode: Int, resultCode: Int, data: Intent?) -> Unit
    ) {
        this.onResult = onResult
        val intent = Intent(this, ScanActivity::class.java)
        intent.putExtra(ScanActivity.SCAN_CONFIGURATION, hashMapOf<String?, Int>().apply {
            this[cardHolderName] = ScanActivity.CARD_HOLDER
            this[cardNumber] = ScanActivity.CARD_NUMBER
            this[expiry] = ScanActivity.CARD_EXP_DATE
            this[cvc] = ScanActivity.CARD_CVC
        })

        startActivityForResult(intent, 1)
    }
}
