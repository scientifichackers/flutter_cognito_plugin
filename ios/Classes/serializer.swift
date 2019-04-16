import AWSMobileClient
import Flutter


// Here's some Python code to generate error handling code :-)
//
// errors = [
//     'aliasExists',
//     'codeDeliveryFailure',
//     'codeMismatch',
//     'expiredCode',
//     'groupExists',
//     'internalError',
//     'invalidLambdaResponse',
//     'invalidOAuthFlow',
//     'invalidParameter',
//     'invalidPassword',
//     'invalidUserPoolConfiguration',
//     'limitExceeded',
//     'mfaMethodNotFound',
//     'notAuthorized',
//     'passwordResetRequired',
//     'resourceNotFound',
//     'scopeDoesNotExist',
//     'softwareTokenMFANotFound',
//     'tooManyFailedAttempts',
//     'tooManyRequests',
//     'unexpectedLambda',
//     'userLambdaValidation',
//     'userNotConfirmed',
//     'userNotFound',
//     'usernameExists',
//     'unknown',
//     'notSignedIn',
//     'identityIdUnavailable',
//     'guestAccessNotAllowed',
//     'federationProviderExists',
//     'cognitoIdentityPoolNotConfigured',
//     'unableToSignIn',
//     'invalidState',
//     'userPoolNotConfigured',
//     'userCancelledSignIn',
//     'badRequest',
//     'expiredRefreshToken',
//     'errorLoadingPage',
//     'securityFailed',
//     'idTokenNotIssued',
//     'idTokenAndAcceessTokenNotIssued',
//     'invalidConfiguration',
//     'deviceNotRemembered'
// ]
//
// for name in errors:
//     print(
//     """catch AWSMobileClientError.%(name)s(let message) {
//             flutterError = FlutterError(
//             code: "AWSMobileClientError.%(name)s",
//             message: message,
//             details: nil
//         )
//     }""" % {"name": name},
//         end=" "
//     )

func dumpError(_ e: Error) -> FlutterError {
    var flutterError: FlutterError
    do {
        throw e
    } catch AWSMobileClientError.aliasExists(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.aliasExists",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.codeDeliveryFailure(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.codeDeliveryFailure",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.codeMismatch(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.codeMismatch",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.expiredCode(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.expiredCode",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.groupExists(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.groupExists",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.internalError(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.internalError",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidLambdaResponse(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidLambdaResponse",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidOAuthFlow(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidOAuthFlow",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidParameter(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidParameter",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidPassword(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidPassword",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidUserPoolConfiguration(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidUserPoolConfiguration",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.limitExceeded(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.limitExceeded",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.mfaMethodNotFound(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.mfaMethodNotFound",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.notAuthorized(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.notAuthorized",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.passwordResetRequired(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.passwordResetRequired",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.resourceNotFound(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.resourceNotFound",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.scopeDoesNotExist(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.scopeDoesNotExist",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.softwareTokenMFANotFound(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.softwareTokenMFANotFound",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.tooManyFailedAttempts(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.tooManyFailedAttempts",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.tooManyRequests(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.tooManyRequests",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.unexpectedLambda(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.unexpectedLambda",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.userLambdaValidation(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.userLambdaValidation",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.userNotConfirmed(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.userNotConfirmed",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.userNotFound(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.userNotFound",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.usernameExists(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.usernameExists",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.unknown(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.unknown",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.notSignedIn(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.notSignedIn",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.identityIdUnavailable(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.identityIdUnavailable",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.guestAccessNotAllowed(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.guestAccessNotAllowed",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.federationProviderExists(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.federationProviderExists",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.cognitoIdentityPoolNotConfigured(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.cognitoIdentityPoolNotConfigured",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.unableToSignIn(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.unableToSignIn",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidState(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidState",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.userPoolNotConfigured(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.userPoolNotConfigured",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.userCancelledSignIn(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.userCancelledSignIn",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.badRequest(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.badRequest",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.expiredRefreshToken(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.expiredRefreshToken",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.errorLoadingPage(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.errorLoadingPage",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.securityFailed(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.securityFailed",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.idTokenNotIssued(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.idTokenNotIssued",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.idTokenAndAcceessTokenNotIssued(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.idTokenAndAcceessTokenNotIssued",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.invalidConfiguration(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.invalidConfiguration",
                message: message,
                details: nil
        )
    } catch AWSMobileClientError.deviceNotRemembered(let message) {
        flutterError = FlutterError(
                code: "AWSMobileClientError.deviceNotRemembered",
                message: message,
                details: nil
        )
    } catch {
        flutterError = FlutterError(
                code: String(describing: error.self),
                message: error.localizedDescription,
                details: nil
        )
    }
    return flutterError
}

func dumpUserCodeDeliveryDetails(_ userCodeDeliveryDetails: UserCodeDeliveryDetails?) -> [String] {
    if (userCodeDeliveryDetails == nil) {
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
    ForgotPasswordState.done,
]

func dumpForgotPasswordResult(_ forgotPasswordResult: ForgotPasswordResult) -> [Any] {
    return [
        _androidForgotPasswordStateEnum.firstIndex(of: forgotPasswordResult.forgotPasswordState)!
    ] + dumpUserCodeDeliveryDetails(
            forgotPasswordResult.codeDeliveryDetails
    )
}

func dumpTokensResult(_ tokensResult: Tokens) -> [Any] {
    return [
        tokensResult.accessToken?.tokenString ?? "null",
        tokensResult.idToken?.tokenString ?? "null",
        tokensResult.refreshToken?.tokenString ?? "null"
    ]
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
