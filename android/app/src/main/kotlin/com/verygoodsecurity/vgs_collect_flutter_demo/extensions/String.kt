package com.verygoodsecurity.vgs_collect_flutter_demo.extensions

import com.google.gson.Gson
import org.json.JSONArray

private const val DEFAULT_INDENT_SPACES = 4

inline fun <reified T> String.fromJson(): T? {
    return try {
        Gson().fromJson(this, T::class.java)
    } catch (e: Exception) {
        null
    }
}

fun String.toFormattedJson(indentSpaces: Int = DEFAULT_INDENT_SPACES): String? {
    return try {
        JSONArray(this).toString(indentSpaces)
    } catch (e: Exception) {
        null
    }
}