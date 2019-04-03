package com.pycampers.flutter_cognito_plugin

import android.content.Context
import com.amazonaws.mobile.client.AWSMobileClient
import com.amazonaws.mobile.client.Callback
import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.mobile.client.results.ForgotPasswordResult
import com.amazonaws.mobile.client.results.SignInResult
import com.amazonaws.mobile.client.results.SignUpResult
import com.amazonaws.mobile.client.results.UserCodeDeliveryDetails
import io.flutter.plugin.common.MethodChannel

class Cognito(val context: Context, val methodChannel: MethodChannel) : MethodCallDispatcher() {
    val awsClient = AWSMobileClient.getInstance()!!

    fun initialize() {
        awsClient.initialize(context, object : Callback<UserStateDetails> {
            override fun onResult(u: UserStateDetails) {
                awsClient.addUserStateListener {
                    methodChannel.invokeMethod(
                            "userStateCallback",
                            dumpUserState(it)
                    )
                }
                result.success(dumpUserState(u))
                initialized = true
            }

            override fun onError(e: Exception) {
                throw e
            }
        })
    }

    fun signUp() {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")
        val userAttributes = call.argument<Map<String, String>>("userAttributes")

        awsClient.signUp(username, password, userAttributes, null, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = result.success(dumpSignUpResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmSignUp() {
        val username = call.argument<String>("username")
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmSignUp(username, confirmationCode, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = result.success(dumpSignUpResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun resendSignUp() {
        val username = call.argument<String>("username")

        awsClient.resendSignUp(username, object : Callback<SignUpResult> {
            override fun onResult(s: SignUpResult) = result.success(dumpSignUpResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun signIn() {
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")

        awsClient.signIn(username, password, null, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = result.success(dumpSignInResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmSignIn() {
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmSignIn(confirmationCode, object : Callback<SignInResult> {
            override fun onResult(s: SignInResult) = result.success(dumpSignInResult(s))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun forgotPassword() {
        val username = call.argument<String>("username")

        awsClient.forgotPassword(username, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) = result.success(dumpForgotPasswordResult(f))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmForgotPassword() {
        val newPassword = call.argument<String>("newPassword")
        val confirmationCode = call.argument<String>("confirmationCode")

        awsClient.confirmForgotPassword(newPassword, confirmationCode, object : Callback<ForgotPasswordResult> {
            override fun onResult(f: ForgotPasswordResult) = result.success(dumpForgotPasswordResult(f))
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun signOut() {
        try {
            awsClient.signOut()
            result.success(null)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun getUsername() {
        try {
            result.success(awsClient.username)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun isSignedIn() {
        try {
            result.success(awsClient.isSignedIn)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun getIdentityId() {
        try {
            result.success(awsClient.identityId)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun currentUserState() {
        try {
            result.success(dumpUserState(awsClient.currentUserState()))
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun getUserAttributes() {
        try {
            result.success(awsClient.userAttributes)
        } catch (e: Exception) {
            dumpException(e, result)
        }
    }

    fun updateUserAttributes() {
        val userAttributes = call.argument<Map<String, String>>("userAttributes")!!

        awsClient.updateUserAttributes(userAttributes, object : Callback<List<UserCodeDeliveryDetails>> {
            override fun onResult(u: List<UserCodeDeliveryDetails>) = result.success(u.map { dumpUserCodeDeliveryDetails(it) })
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }

    fun confirmUpdateUserAttribute() {
        val attributeName = call.argument<String>("attributeName")!!
        val confirmationCode = call.argument<String>("confirmationCode")!!

        awsClient.confirmUpdateUserAttribute(attributeName, confirmationCode, object : Callback<Void> {
            override fun onResult(u: Void) = result.success(u)
            override fun onError(e: Exception) = dumpException(e, result)
        })
    }
}