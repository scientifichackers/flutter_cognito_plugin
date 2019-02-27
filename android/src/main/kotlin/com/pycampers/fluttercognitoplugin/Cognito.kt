package com.pycampers.fluttercognitoplugin

import android.content.Context
import com.amazonaws.mobile.client.AWSMobileClient
import com.amazonaws.mobile.client.Callback
import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.mobile.client.results.ForgotPasswordResult
import com.amazonaws.mobile.client.results.SignInResult
import com.amazonaws.mobile.client.results.SignUpResult
import com.amazonaws.mobile.client.results.UserCodeDeliveryDetails
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class Cognito(val context: Context, val methodChannel: MethodChannel) : MethodCallDispatcher() {
    val awsClient = AWSMobileClient.getInstance()!!

    fun initialize(result: Result) {
        awsClient.initialize(context, object : Callback<UserStateDetails> {
            override fun onResult(u: UserStateDetails) {
                awsClient.addUserStateListener {
                    methodChannel.invokeMethod(
                            "userStateCallback",
                            dumpUserStateDetails(it)
                    )
                }
                result.success(dumpUserStateDetails(u))
                initialized = true
            }

            override fun onError(e: Exception) {
                throw e
            }
        })
    }

    fun signUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")
        val userAttributes = call.argument<Map<String, String>>("userAttributes")

        awsClient.signUp(username, password, userAttributes, null, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = result.success(dumpSignUpResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmSignUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val signUpChallengeResponse = call.argument<String>("signUpChallengeResponse")

        awsClient.confirmSignUp(username, signUpChallengeResponse, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = result.success(dumpSignUpResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun resendSignUp(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")

        awsClient.resendSignUp(username, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = result.success(dumpSignUpResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun signIn(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")

        awsClient.signIn(username, password, null, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = result.success(dumpSignInResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmSignIn(call: MethodCall, result: Result) {
        val signInChallengeResponse = call.argument<String>("signInChallengeResponse")

        awsClient.confirmSignIn(signInChallengeResponse, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = result.success(dumpSignInResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun forgotPassword(call: MethodCall, result: Result) {
        val username = call.argument<String>("username")

        awsClient.forgotPassword(username, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) = result.success(dumpForgotPasswordResult(f))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmForgotPassword(call: MethodCall, result: Result) {
        val newPassword = call.argument<String>("newPassword")
        val forgotPasswordChallengeResponse = call.argument<String>("forgotPasswordChallengeResponse")

        awsClient.confirmForgotPassword(newPassword, forgotPasswordChallengeResponse, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) = result.success(dumpForgotPasswordResult(f))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun signOut(result: Result) {
        try {
            awsClient.signOut()
            result.success(true)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun getUsername(result: Result) {
        try {
            result.success(awsClient.username)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun isSignedIn(result: Result) {
        try {
            result.success(awsClient.isSignedIn)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun getIdentityId(result: Result) {
        try {
            result.success(awsClient.identityId)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun currentUserState(result: Result) {
        try {
            result.success(dumpUserStateDetails(awsClient.currentUserState()))
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun getUserAttributes(result: Result) {
        try {
            result.success(awsClient.userAttributes)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun updateUserAttributes(call: MethodCall, result: Result) {
        val userAttributes = call.argument<Map<String, String>>("userAttributes")!!

        awsClient.updateUserAttributes(userAttributes, object : Callback<List<UserCodeDeliveryDetails>> {
            override fun onResult(u: List<UserCodeDeliveryDetails>) = result.success(u.map { dumpUserCodeDeliveryDetails(it) })
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmUpdateUserAttribute(call: MethodCall, result: Result) {
        val attributeName = call.argument<String>("attributeName")!!
        val updateUserAttributeChallengeResponse = call.argument<String>("updateUserAttributeChallengeResponse")!!

        awsClient.confirmUpdateUserAttribute(attributeName, updateUserAttributeChallengeResponse, object : Callback<Void> {
            override fun onResult(u: Void) = result.success(u)
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }
}