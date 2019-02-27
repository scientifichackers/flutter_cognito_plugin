package com.pycampers.fluttercognitoplugin

import com.amazonaws.AmazonServiceException
import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.mobile.client.results.ForgotPasswordResult
import com.amazonaws.mobile.client.results.SignInResult
import com.amazonaws.mobile.client.results.SignUpResult
import com.amazonaws.mobile.client.results.UserCodeDeliveryDetails
import io.flutter.plugin.common.MethodChannel

fun dumpException(e: Exception, result: MethodChannel.Result) {
    try {
        throw e
    } catch (e: AmazonServiceException) {
        result.error(e.errorCode, e.errorMessage, e.errorType.ordinal)
    } catch (e: Exception) {
        result.error(e.javaClass.canonicalName, e.message, null)
    }
}

fun dumpUserCodeDeliveryDetails(u: UserCodeDeliveryDetails?): List<String> {
    return if (u != null) {
        listOf(u.attributeName, u.destination, u.deliveryMedium)
    } else {
        listOf()
    }
}

fun dumpSignUpResult(signUpResult: SignUpResult): List<*> {
    return listOf(
            signUpResult.confirmationState
    ) + dumpUserCodeDeliveryDetails(
            signUpResult.userCodeDeliveryDetails
    )
}

fun dumpSignInResult(signInResult: SignInResult): List<*> {
    return listOf(
            signInResult.signInState.ordinal,
            signInResult.parameters
    ) + dumpUserCodeDeliveryDetails(
            signInResult.codeDetails
    )
}

fun dumpForgotPasswordResult(forgotPasswordResult: ForgotPasswordResult): List<*> {
    return listOf(
            forgotPasswordResult.state.ordinal
    ) + dumpUserCodeDeliveryDetails(
            forgotPasswordResult.parameters
    )
}

fun dumpUserStateDetails(userStateDetails: UserStateDetails): List<*> {
    return listOf(
            userStateDetails.userState.ordinal,
            userStateDetails.details
    )
}