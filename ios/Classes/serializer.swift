import AWSMobileClient
import Flutter

func dumpUserCodeDeliveryDetails(_ userCodeDeliveryDetails: UserCodeDeliveryDetails?) -> [String] {
    if userCodeDeliveryDetails == nil {
        return []
    }

    let u = userCodeDeliveryDetails!
    return [
        u.attributeName!,
        u.destination!,
        String(describing: u.deliveryMedium)
    ]
}

func dumpSignUpResult(_ signUpResult: SignUpResult) -> [Any] {
    return [
        signUpResult.signUpConfirmationState == SignUpConfirmationState.confirmed
    ] + dumpUserCodeDeliveryDetails(
        signUpResult.codeDeliveryDetails
    )
}

let _androidSignInStateEnum = [
    SignInState.smsMFA,
    SignInState.passwordVerifier,
    SignInState.customChallenge,
    SignInState.deviceSRPAuth,
    SignInState.devicePasswordVerifier,
    SignInState.adminNoSRPAuth,
    SignInState.newPasswordRequired,
    SignInState.signedIn,
    SignInState.unknown
]

func dumpSignInResult(_ signInResult: SignInResult) -> [Any] {
    return [
        _androidSignInStateEnum.firstIndex(of: signInResult.signInState)!,
        signInResult.parameters
    ] + dumpUserCodeDeliveryDetails(
        signInResult.codeDetails
    )
}

let _androidForgotPasswordStateEnum = [
    ForgotPasswordState.confirmationCodeSent,
    ForgotPasswordState.done
]

func dumpForgotPasswordResult(_ forgotPasswordResult: ForgotPasswordResult) -> [Any] {
    return [
        _androidForgotPasswordStateEnum.firstIndex(of: forgotPasswordResult.forgotPasswordState)!
    ] + dumpUserCodeDeliveryDetails(
        forgotPasswordResult.codeDeliveryDetails
    )
}

let _androidUserStateEnum = [
    UserState.signedIn,
    UserState.guest,
    UserState.signedOutFederatedTokensInvalid,
    UserState.signedOutUserPoolsTokenInvalid,
    UserState.signedOut,
    UserState.unknown
]

func dumpUserState(_ userState: UserState) -> Int {
    return _androidUserStateEnum.firstIndex(of: userState)!
}

func dumpTokens(_ tokens: Tokens) -> [String?] {
    return [tokens.accessToken?.tokenString, tokens.idToken?.tokenString, tokens.refreshToken?.tokenString]
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

func dumpCredentials(_ credentials: AWSCredentials) -> [Any?] {
    return [
        credentials.accessKey,
        credentials.secretKey,
        credentials.sessionKey,
        credentials.expiration?.millisecondsSince1970
    ]
}
