package com.pycampers.flutter_cognito_plugin

import android.content.Context
import com.amazonaws.mobile.client.AWSMobileClient
import com.amazonaws.mobile.client.Callback
import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.mobile.client.UserStateListener
import com.amazonaws.mobile.client.results.ForgotPasswordResult
import com.amazonaws.mobile.client.results.SignInResult
import com.amazonaws.mobile.client.results.SignUpResult
import com.amazonaws.mobile.client.results.Tokens
import com.amazonaws.mobile.client.results.UserCodeDeliveryDetails
import com.pycampers.method_call_dispatcher.MethodCallDispatcher
import com.pycampers.method_call_dispatcher.trySend
import com.pycampers.method_call_dispatcher.trySendThrowable
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

const val PKG_NAME = "com.pycampers.flutter_cognito_plugin"

class FlutterCognitoPlugin(val context: Context, val methodChannel: MethodChannel) : MethodCallDispatcher(),
    UserStateListener {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), PKG_NAME)
            val plugin = FlutterCognitoPlugin(registrar.context(), channel)
            channel.setMethodCallHandler(plugin)
        }
    }

    val awsClient = AWSMobileClient.getInstance()!!

    override fun onUserStateChanged(it: UserStateDetails) {
        methodChannel.invokeMethod("userStateCallback", dumpUserState(it))
    }

    fun initialize(call: MethodCall, result: Result) {
        val that = this
        awsClient.initialize(context, object : Callback<UserStateDetails> {
            override fun onResult(u: UserStateDetails) {
                awsClient.removeUserStateListener(that)
                awsClient.addUserStateListener(that)
                trySend(result) { dumpUserState(u) }
            }

            override fun onError(e: Exception) {
                trySendThrowable(result, e)
            }
        })
    }

    fun signUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")
        val userAttributes = call.argument<Map<String, String>>("userAttributes")

        awsClient.signUp(username, password, userAttributes, null, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = trySend(result) { dumpSignUpResult(s) }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun confirmSignUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmSignUp(username, confirmationCode, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = trySend(result) { dumpSignUpResult(s) }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun resendSignUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")

        awsClient.resendSignUp(username, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = trySend(result) { dumpSignUpResult(s) }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun signIn(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")

        awsClient.signIn(username, password, null, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = trySend(result) { dumpSignInResult(s) }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun confirmSignIn(call: MethodCall, result: Result) {
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmSignIn(confirmationCode, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = trySend(result) { dumpSignInResult(s) }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun forgotPassword(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")

        awsClient.forgotPassword(username, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) {
                trySend(result) { dumpForgotPasswordResult(f) }
            }

            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun confirmForgotPassword(call: MethodCall, result: Result) {
        val newPassword = call.argument<String>("newPassword")
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmForgotPassword(newPassword, confirmationCode, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) = trySend(result) { dumpForgotPasswordResult(f) }

            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun getUserAttributes(call: MethodCall, result: Result) {
        awsClient.getUserAttributes(object : Callback<Map<String, String>> {
            override fun onResult(attrs: Map<String, String>?) = trySend(result) { attrs }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun updateUserAttributes(call: MethodCall, result: Result) {
        val userAttributes = call.argument<Map<String, String>>("userAttributes")!!

        awsClient.updateUserAttributes(userAttributes, object : Callback<List<UserCodeDeliveryDetails>> {
            override fun onResult(u: List<UserCodeDeliveryDetails>) = trySend(result) {
                u.map { dumpUserCodeDeliveryDetails(it) }
            }

            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun confirmUpdateUserAttribute(call: MethodCall, result: Result) {
        val attributeName = call.argument<String>("attributeName")!!
        val confirmationCode = call.argument<String>("confirmationCode")!!

        awsClient.confirmUpdateUserAttribute(attributeName, confirmationCode, object : Callback<Void> {
            override fun onResult(u: Void) = trySend(result) { (u) }
            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }

    fun signOut(call: MethodCall, result: Result) {
        trySend(result) { awsClient.signOut() }
    }

    fun getUsername(call: MethodCall, result: Result) {
        trySend(result) { awsClient.username }
    }

    fun isSignedIn(call: MethodCall, result: Result) {
        trySend(result) { awsClient.isSignedIn }
    }

    fun getIdentityId(call: MethodCall, result: Result) {
        trySend(result) { awsClient.identityId }
    }

    fun currentUserState(call: MethodCall, result: Result) {
        trySend(result) { awsClient.currentUserState()?.userState?.ordinal }
    }

    fun getTokens(call: MethodCall, result: Result) {
        awsClient.getTokens(object : Callback<Tokens> {
            override fun onResult(t: Tokens?) = trySend(result) {
                listOf(
                    t?.accessToken?.tokenString,
                    t?.idToken?.tokenString,
                    t?.refreshToken?.tokenString
                )
            }

            override fun onError(e: Exception) = trySendThrowable(result, e)
        })
    }
}
