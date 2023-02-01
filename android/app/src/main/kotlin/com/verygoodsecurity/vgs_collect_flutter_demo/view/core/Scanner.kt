package com.verygoodsecurity.vgs_collect_flutter_demo.view.core

import android.content.Intent

interface Scanner {

    fun start(
        params: ScannerParams,
        onResult: (requestCode: Int, resultCode: Int, data: Intent?) -> Unit
    )

    companion object {

        const val RESULT_CODE_CANCEL = 0
    }
}