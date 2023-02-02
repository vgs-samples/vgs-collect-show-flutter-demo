package com.verygoodsecurity.vgs_collect_flutter_demo.view.core

sealed class ScannerParams {

    abstract val cardNumberFieldName: String

    abstract val cardHolderNameFieldName: String

    abstract val expiryFieldName: String

    abstract val cvcFieldName: String

    data class CardIO(
        override val cardNumberFieldName: String,
        override val cardHolderNameFieldName: String,
        override val expiryFieldName: String,
        override val cvcFieldName: String
    ) : ScannerParams()

    data class Blinkcard(
        override val cardNumberFieldName: String,
        override val cardHolderNameFieldName: String,
        override val expiryFieldName: String,
        override val cvcFieldName: String,
        val licenseKey: String
    ) : ScannerParams()
}