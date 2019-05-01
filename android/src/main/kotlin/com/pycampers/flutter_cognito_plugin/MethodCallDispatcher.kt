package com.pycampers.flutter_cognito_plugin

import android.os.AsyncTask
import android.util.Log
import com.amazonaws.AmazonServiceException
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

/*
run `fn`, ignoring `IllegalStateException`.
(workaround for https://github.com/flutter/flutter/issues/29092.)
*/
fun ignoreIllegalState(fn: () -> Unit) {
    try {
        fn()
    } catch (e: IllegalStateException) {
        Log.d(TAG, "ignoring exception: $e. See https://github.com/flutter/flutter/issues/29092 for details.")
    }
}

/*
try to send the value returned by `fn()` using `result`.
sends an error using `sendError` if required.
*/
fun <T> trySend(result: Result, fn: () -> T) {
    val value: T
    try {
        value = fn()
    } catch (e: Throwable) {
        sendError(e, result)
        return
    }

    ignoreIllegalState {
        if (value is Unit) {
            result.success(null)
        } else {
            result.success(value)
        }
    }
}

/* pipe the exception `e` back to flutter using `result.error()`. */
fun sendError(e: Throwable, result: Result) {
    Log.d(TAG, "piping exception to flutter: $e")
    e.printStackTrace()
    try {
        throw e
    } catch (e: AmazonServiceException) {
        ignoreIllegalState { result.error(e.errorCode, e.errorMessage, e.errorType.name) }
    } catch (e: Throwable) {
        ignoreIllegalState { result.error(e.javaClass.canonicalName, e.message, null) }
    }
}

/*
inherit this class to make any kotlin methods with the signature:-

    `methodName(io.flutter.plugin.common.MethodCall, io.flutter.plugin.common.MethodChannel.Result)`

be magically available to flutter, by the power of dynamic dispatch!
*/
open class MethodCallDispatcher : MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: Result) {
        val methodName = call.method

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
            return
        }

        DoAsync {
            Log.d(TAG, "invoking { ${javaClass.simpleName}.$methodName() }...")
            try {
                ignoreIllegalState { method.invoke(this, call, result) }
            } catch (e: Throwable) {
                sendError(e, result)
            }
        }
    }
}