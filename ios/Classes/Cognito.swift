import AWSMobileClient
import Flutter

class Cognito: MethodCallDispatcher {
    let awsClient = AWSMobileClient.sharedInstance()

    @objc func initialize(_ method: FlutterMethod) {
        print(Thread
        .isMainThread)
        awsClient.initialize { userState, error in
            awsCallback(userState, error, method.result, dumpUserState)
        }
    }

    @objc func signUp(_ method: FlutterMethod) {
        let username = method.args["username"] as! String
        let password = method.args["password"] as! String
        let attrs = method.args["userAttributes"] as! [String: String]

        awsClient.signUp(
            username: username,
            password: password,
            userAttributes: attrs,
            validationData: [:]
        ) { result, error in
            awsCallback(result, error, method.result, dumpSignUpResult)
        }
    }

    @objc func confirmSignUp(_ method: FlutterMethod) {
        let username = method.args["username"] as! String
        let confirmationCode = method.args["confirmationCode"] as! String

        awsClient.confirmSignUp(
            username: username,
            confirmationCode: confirmationCode
        ) { result, error in
            awsCallback(result, error, method.result, dumpSignUpResult)
        }
    }

    @objc func resendSignUp(_ method: FlutterMethod) {
        let username = method.args["username"] as! String

        awsClient.resendSignUpCode(
            username: username
        ) { result, error in
            awsCallback(result, error, method.result, dumpSignUpResult)
        }
    }

    @objc func signIn(_ method: FlutterMethod) {
        let username = method.args["username"] as! String
        let password = method.args["password"] as! String

        awsClient.signIn(
            username: username, password: password
        ) { result, error in
            awsCallback(result, error, method.result, dumpSignInResult)
        }
    }

    @objc func confirmSignIn(_ method: FlutterMethod) {
        let confirmationCode = method.args["confirmationCode"] as! String

        awsClient.confirmSignIn(
            challengeResponse: confirmationCode
        ) { result, error in
            awsCallback(result, error, method.result, dumpSignInResult)
        }
    }

    @objc func forgotPassword(_ method: FlutterMethod) {
        let username = method.args["username"] as! String

        awsClient.forgotPassword(username: username) { result, error in
            awsCallback(result, error, method.result, dumpForgotPasswordResult)
        }
    }

    @objc func confirmForgotPassword(_ method: FlutterMethod) {
        let username = method.args["username"] as! String
        let newPassword = method.args["newPassword"] as! String
        let confirmationCode = method.args["confirmationCode"] as! String

        awsClient.confirmForgotPassword(
            username: username,
            newPassword: newPassword,
            confirmationCode: confirmationCode
        ) { result, error in
            awsCallback(result, error, method.result, dumpForgotPasswordResult)
        }
    }

    @objc func signOut(_ method: FlutterMethod) {
        awsClient.signOut()
        method.result(nil)
    }

    @objc func getUsername(_ method: FlutterMethod) {
        method.result(awsClient.username)
    }

    @objc func isSignedIn(_ method: FlutterMethod) {
        method.result(awsClient.isSignedIn)
    }

    @objc func getIdentityId(_ method: FlutterMethod) {
        method.result(awsClient.identityId)
    }

    @objc func getTokens(_ method: FlutterMethod) {
        awsClient.getTokens { tokens, error in
            awsCallback(tokens, error, method.result, dumpTokensResult)
        }
    }

    @objc func currentUserState(_ method: FlutterMethod) {
        method.result(awsClient.currentUserState)
    }

    @objc func getUserAttributes(_ method: FlutterMethod) {
        awsClient.getUserAttributes { result, error in
            awsCallback(result, error, method.result) { (attrs) -> Any in
                attrs
            }
        }
    }

    @objc func updateUserAttributes(_ method: FlutterMethod) {
        let userAttributes = method.args["userAttributes"] as! [String: String]

        awsClient.updateUserAttributes(
            attributeMap: userAttributes
        ) { result, error in
            awsCallback(result, error, method.result) { (u) -> Any in
                u.map { (it) -> Any in
                    dumpUserCodeDeliveryDetails(it)
                }
            }
        }
    }

    @objc func confirmUpdateUserAttribute(_ method: FlutterMethod) {
        let attributeName = method.args["attributeName"] as! String
        let confirmationCode = method.args["confirmationCode"] as! String

        awsClient.confirmUpdateUserAttributes(
            attributeName: attributeName, code: confirmationCode
        ) { error in
            if let error = error {
                method.result(dumpError(error))
            } else {
                method.result(nil)
            }
        }
    }
}
