package com.pycampers.flutter_cognito_plugin

import android.os.AsyncTask
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

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
                    "You must call `initialize()` before using this plugin!",
                    null
            )
        }

        val method = try {
            javaClass.getMethod(methodName, MethodCall::class.java, Result::class.java)
        } catch (e: java.lang.Exception) {
            when (e) {
                is NoSuchMethodException, is SecurityException -> null
                else -> throw e
            }
        }

        if (method == null) {
            result.notImplemented()
        } else {
            DoAsync { method.invoke(this, call, result) }
        }
    }
}