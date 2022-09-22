package com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo

import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.collect.CardCollectViewFactory
import com.vgs.showcollect.flutter.vgs_show_collect_flutter_demo.view.reveal.CardShowViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.verygoodsecurity.vgscollect.core.VGSCollect

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val registry = flutterEngine.platformViewsController.registry
        registry.registerViewFactory(
            COLLECT_FORM_VIEW_TYPE,
            CardCollectViewFactory(
                flutterEngine.dartExecutor.binaryMessenger,
                VGSCollect(this, VAULT_ID, ENVIRONMENT)
            )
        )
        registry.registerViewFactory(
            SHOW_FORM_VIEW_TYPE,
            CardShowViewFactory(flutterEngine.dartExecutor.binaryMessenger)
        )
    }

    companion object {

        const val VAULT_ID = "tntpszqgikn"
        const val ENVIRONMENT = "sandbox"

        const val COLLECT_FORM_VIEW_TYPE = "card-collect-form-view";
        const val SHOW_FORM_VIEW_TYPE = "card-show-form-view";
    }
}
