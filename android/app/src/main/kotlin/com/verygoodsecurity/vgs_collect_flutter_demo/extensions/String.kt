package com.verygoodsecurity.vgs_collect_flutter_demo.extensions

import org.json.JSONArray

private const val DEFAULT_INDENT_SPACES = 4

fun String.toFormattedJson(indentSpaces: Int = DEFAULT_INDENT_SPACES): String? {
    return try {
        JSONArray(this).toString(indentSpaces)
    } catch (e: Exception) {
        null
    }
}