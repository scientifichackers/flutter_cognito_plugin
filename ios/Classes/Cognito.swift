import AWSMobileClient
import Flutter
import plugin_scaffold

typealias CompletionCallback<T> = (T?, Error?) -> Void

class Cognito {
    let awsClient = AWSMobileClient.sharedInstance()

    func createErrorCallback(_ result: @escaping FlutterResult) -> (Error?) -> Void {
        return { error in
            if let error = error {
                trySendError(result, error)
            } else {
                trySend(result) { nil }
            }
        }
    }

    func createCallback<T>(_ result: @escaping FlutterResult, _ serializer: ((T) -> Any)? = nil) -> (T?, Error?) -> Void {
        return { obj, error in
            if let obj = obj {
                trySend(result) {
                    let value = serializer?(obj) ?? obj
                    return value
                }
            } else if let error = error {
                trySendError(result, error)
            }
        }
    }

    func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.awsClient.initialize(self.createCallback(result, dumpUserState))
    }

    func signUp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String
        let password = args["password"] as! String
        let attrs = args["userAttributes"] as! [String: String]

        awsClient.signUp(
            username: username,
            password: password,
            userAttributes: attrs,
            validationData: [:],
            completionHandler: createCallback(result, dumpSignUpResult)
        )
    }

    func confirmSignUp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String
        let confirmationCode = args["confirmationCode"] as! String

        awsClient.confirmSignUp(
            username: username,
            confirmationCode: confirmationCode,
            completionHandler: createCallback(result, dumpSignUpResult)
        )
    }

    func resendSignUp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String

        awsClient.resendSignUpCode(
            username: username,
            completionHandler: createCallback(result, dumpSignUpResult)
        )
    }

    func signIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String
        let password = args["password"] as! String
        
        awsClient.signIn(
            username: username,
            password: password,
            validationData: [:],
            completionHandler: createCallback(result, dumpSignInResult)
        )
    }

    func confirmSignIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let confirmationCode = args["confirmationCode"] as! String

        awsClient.confirmSignIn(
            challengeResponse: confirmationCode,
            completionHandler: createCallback(result, dumpSignInResult)
        )
    }

    func forgotPassword(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String

        awsClient.forgotPassword(
            username: username,
            completionHandler: createCallback(result, dumpForgotPasswordResult)
        )
    }

    func confirmForgotPassword(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String
        let newPassword = args["newPassword"] as! String
        let confirmationCode = args["confirmationCode"] as! String

        awsClient.confirmForgotPassword(
            username: username,
            newPassword: newPassword,
            confirmationCode: confirmationCode,
            completionHandler: createCallback(result, dumpForgotPasswordResult)
        )
    }

    func updateUserAttributes(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let userAttributes = args["userAttributes"] as! [String: String]

        awsClient.updateUserAttributes(
            attributeMap: userAttributes,
            completionHandler: createCallback(result) {
                $0.map { dumpUserCodeDeliveryDetails($0) }
            }
        )
    }

    func getUserAttributes(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.awsClient.getUserAttributes(completionHandler: self.createCallback(result))
    }

    func confirmUpdateUserAttribute(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let attributeName = args["attributeName"] as! String
        let confirmationCode = args["confirmationCode"] as! String

        awsClient.confirmUpdateUserAttributes(
            attributeName: attributeName, code: confirmationCode,
            completionHandler: createErrorCallback(result)
        )
    }

    func signOut(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.awsClient.signOut()
        result(nil)
    }

    func getUsername(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(self.awsClient.username)
    }

    func isSignedIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(self.awsClient.isSignedIn)
    }

    func getIdentityId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(self.awsClient.identityId)
    }

    func currentUserState(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(dumpUserState(self.awsClient.currentUserState))
    }

    func getTokens(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.awsClient.getTokens(self.createCallback(result, dumpTokens))
    }

    func federatedSignIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any?]
        let providerName = args["providerName"] as! String
        let token = args["token"] as! String

        awsClient.federatedSignIn(
            providerName: providerName,
            token: token,
            completionHandler: createCallback(result, dumpUserState)
        )
    }
}
