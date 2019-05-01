package com.pycampers.flutter_cognito_plugin

import com.amazonaws.mobile.client.UserStateDetails
import com.amazonaws.mobile.client.results.ForgotPasswordResult
import com.amazonaws.mobile.client.results.SignInResult
import com.amazonaws.mobile.client.results.SignUpResult
import com.amazonaws.mobile.client.results.UserCodeDeliveryDetails

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

fun dumpUserState(userStateDetails: UserStateDetails): Int {
    return userStateDetails.userState.ordinal
}
