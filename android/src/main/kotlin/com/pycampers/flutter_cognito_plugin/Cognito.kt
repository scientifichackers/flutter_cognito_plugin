package com.pycampers.flutter_cognito_plugin

import android.app.Activity
import android.content.Context
import com.amazonaws.auth.CognitoCachingCredentialsProvider
import com.amazonaws.mobile.client.AWSMobileClient
import com.amazonaws.mobile.client.Callback
import com.amazonaws.mobile.client.HostedUIOptions
import com.amazonaws.mobile.client.SignInUIOptions
import com.amazonaws.mobile.client.SignOutOptions
import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.mobile.client.results.ForgotPasswordResult
import com.amazonaws.mobile.client.results.SignInResult
import com.amazonaws.mobile.client.results.SignUpResult
import com.amazonaws.mobile.client.results.Tokens
import com.amazonaws.mobile.client.results.UserCodeDeliveryDetails
import com.pycampers.plugin_scaffold.sendThrowable
import com.pycampers.plugin_scaffold.trySend
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class Cognito(val context: Context) {
    var activity: Activity? = null
    val awsClient = AWSMobileClient.getInstance()!!

    fun initialize(call: MethodCall, result: Result) {
        awsClient.initialize(context, object : Callback<UserStateDetails> {
            override fun onResult(u: UserStateDetails) {
                trySend(result) { dumpUserState(u) }
            }

            override fun onError(e: Exception) {
                sendThrowable(result, e)
            }
        })
    }

    fun signUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")
        val userAttributes = call.argument<Map<String, String>>("userAttributes")

        awsClient.signUp(username, password, userAttributes, null, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = trySend(result) { dumpSignUpResult(s) }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun confirmSignUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmSignUp(username, confirmationCode, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = trySend(result) { dumpSignUpResult(s) }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun resendSignUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")

        awsClient.resendSignUp(username, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = trySend(result) { dumpSignUpResult(s) }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun signIn(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")

        awsClient.signIn(username, password, null, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = trySend(result) { dumpSignInResult(s) }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun confirmSignIn(call: MethodCall, result: Result) {
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmSignIn(confirmationCode, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = trySend(result) { dumpSignInResult(s) }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun changePassword(call: MethodCall, result: Result) {
        val oldPassword = call.argument<String>("oldPassword")
        val newPassword = call.argument<String>("newPassword")

        awsClient.changePassword(oldPassword, newPassword, object : Callback<Void>  {
            override fun onResult(u: Void?) = trySend(result)
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun forgotPassword(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")

        awsClient.forgotPassword(username, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) {
                trySend(result) { dumpForgotPasswordResult(f) }
            }

            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun confirmForgotPassword(call: MethodCall, result: Result) {
        val newPassword = call.argument<String>("newPassword")
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmForgotPassword(
            newPassword,
            confirmationCode,
            object : Callback<ForgotPasswordResult> {
                override fun onResult(f: ForgotPasswordResult) =
                    trySend(result) { dumpForgotPasswordResult(f) }

                override fun onError(e: Exception) = sendThrowable(result, e)
            })
    }

    fun getUserAttributes(call: MethodCall, result: Result) {
        awsClient.getUserAttributes(object : Callback<Map<String, String>> {
            override fun onResult(attrs: Map<String, String>?) = trySend(result) { attrs }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun updateUserAttributes(call: MethodCall, result: Result) {
        val userAttributes = call.argument<Map<String, String>>("userAttributes")!!

        awsClient.updateUserAttributes(
            userAttributes,
            object : Callback<List<UserCodeDeliveryDetails>> {
                override fun onResult(u: List<UserCodeDeliveryDetails>) {
                    trySend(result) {
                        u.map { dumpUserCodeDeliveryDetails(it) }
                    }
                }

                override fun onError(e: Exception) = sendThrowable(result, e)
            }
        )
    }

    fun confirmUpdateUserAttribute(call: MethodCall, result: Result) {
        val attributeName = call.argument<String>("attributeName")!!
        val confirmationCode = call.argument<String>("confirmationCode")!!

        awsClient.confirmUpdateUserAttribute(
            attributeName,
            confirmationCode,
            object : Callback<Void> {
                override fun onResult(u: Void) = trySend(result) { u }
                override fun onError(e: Exception) = sendThrowable(result, e)
            })
    }

    fun signOut(call: MethodCall, result: Result) {
        val invalidateTokens = call.argument<Boolean>("invalidateTokens")!!
        val signOutGlobally = call.argument<Boolean>("signOutGlobally")!!

        val options = SignOutOptions
            .builder()
            .invalidateTokens(invalidateTokens)
            .signOutGlobally(signOutGlobally)
            .build()

        awsClient.signOut(
            options,
            object : Callback<Void> {
                override fun onResult(v: Void?) = trySend(result)
                override fun onError(e: Exception) = sendThrowable(result, e)
            }
        )
    }

    fun getUsername(call: MethodCall, result: Result) {
        result.success(awsClient.username)
    }

    fun isSignedIn(call: MethodCall, result: Result) {
        result.success(awsClient.isSignedIn)
    }

    fun getIdentityId(call: MethodCall, result: Result) {
        result.success(awsClient.identityId)
    }

    fun currentUserState(call: MethodCall, result: Result) {
        result.success(awsClient.currentUserState()?.userState?.ordinal)
    }

    fun getTokens(call: MethodCall, result: Result) {
        awsClient.getTokens(object : Callback<Tokens> {
            override fun onResult(t: Tokens?) = trySend(result) { t?.let { dumpTokens(it) } ?: t }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun getCredentials(call: MethodCall, result: Result) {
        result.success(
            dumpCredentials(
                CognitoCachingCredentialsProvider(
                    context,
                    awsClient.configuration
                )
            )
        )
    }

    fun federatedSignIn(call: MethodCall, result: Result) {
        val providerName = call.argument<String>("providerName")
        val token = call.argument<String>("token")

        awsClient.federatedSignIn(providerName, token, object : Callback<UserStateDetails> {
            override fun onResult(u: UserStateDetails) = trySend(result) { dumpUserState(u) }
            override fun onError(e: Exception) = sendThrowable(result, e)
        })
    }

    fun showSignIn(call: MethodCall, result: Result) {
        if (activity == null) {
            result.error(
                "ActivityNotAvailable",
                "This method cannot be called without an Activity.\n" +
                    "Did you forget to replace `FlutterActivity` by `CognitoPluginActivity` in your app's    MainActivity.kt?",
                null
            )
            return
        }

        val scopes = call.argument<List<String>>("scopes")!!
        val identityProvider = call.argument<String>("identityProvider")!!

        val hostedUIOptions = HostedUIOptions.builder()
            .scopes(*scopes.toTypedArray())
            .identityProvider(identityProvider)
            .build()
        val signInUIOptions = SignInUIOptions.builder()
            .hostedUIOptions(hostedUIOptions)
            .build()

        AWSMobileClient.getInstance().showSignIn(
            activity,
            signInUIOptions,
            object : Callback<UserStateDetails> {
                override fun onResult(u: UserStateDetails) = trySend(result) { dumpUserState(u) }
                override fun onError(e: Exception) = sendThrowable(result, e)
            }
        )
    }
}
