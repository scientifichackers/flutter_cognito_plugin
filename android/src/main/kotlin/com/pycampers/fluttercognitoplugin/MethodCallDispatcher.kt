package com.pycampers.fluttercognitoplugin

import android.os.AsyncTask
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.reflect.Method


class DoAsync(val fn: () -> Unit) : AsyncTask<Void, Void, Void>() {
    init {
        execute()
    }

    override fun doInBackground(vararg params: Void?): Void? {
        fn()
        return null
    }
}


open class MethodCallDispatcher : MethodCallHandler {
    var initialized = false

    override fun onMethodCall(call: MethodCall, result: Result) {
        val methodName = call.method

        if (!initialized && methodName != "initialize") {
            return result.error(
                    "NotYetInitialized",
                    "You must call initialize() before using this plugin!",
                    null
            )
        }

        var method: Method?

        method = try {
            javaClass.getMethod(
                    methodName,
                    MethodCall::class.java,
                    Result::class.java
            )
        } catch (e: java.lang.Exception) {
            when (e) {
                is NoSuchMethodException, is SecurityException -> null
                else -> throw e
            }
        }
        method?.let {
            DoAsync { it.invoke(this, call, result) }
            return
        }

        method = try {
            javaClass.getMethod(methodName, Result::class.java)
        } catch (e: java.lang.Exception) {
            when (e) {
                is NoSuchMethodException, is SecurityException -> result.notImplemented()
                else -> throw e
            }
            return
        }
        method?.let {
            DoAsync { it.invoke(this, result) }
            return
        }

        result.notImplemented()
    }
}