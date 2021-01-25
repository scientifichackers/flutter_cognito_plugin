import AWSMobileClient
import Flutter
import plugin_scaffold

typealias CompletionCallback<T> = (T?, Error?) -> Void

class Cognito {
    var awsClient: AWSMobileClient?
    var userStateCallback: UserStateChangeCallback?
    private lazy var notInitializedError = FlutterError(
        code: "NotInitialized",
        message: "Call the initialize method first.",
        details: nil
    )

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
        let args = call.arguments as! [String: Any?]
        if let configuration = args["configuration"] as? String,
           let url = Bundle.main.url(forResource: "awsconfiguration", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let obj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
            var config:[String: Any] = [:]
            obj.forEach { (key, value) in
                if var value = value as? [String:Any],
                   let newval = value[configuration] {
                    value["Default"] = newval
                    value[configuration] = nil
                    config[key] = value
                } else {
                    config[key] = value
                }
            }
            self.awsClient = AWSMobileClient(configuration: config)
        } else {
            self.awsClient = AWSMobileClient.default()
        }
        if let callback = userStateCallback {
            let obj = "test" as NSString
            self.awsClient?.removeUserStateListener(obj)
            self.awsClient?.addUserStateListener(obj, callback)
        }
        self.awsClient?.initialize(self.createCallback(result, dumpUserState))
    }

    func signUp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
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
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
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
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String

        awsClient.resendSignUpCode(
            username: username,
            completionHandler: createCallback(result, dumpSignUpResult)
        )
    }

    func signIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
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
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let args = call.arguments as! [String: Any?]
        let confirmationCode = args["confirmationCode"] as! String

        awsClient.confirmSignIn(
            challengeResponse: confirmationCode,
            completionHandler: createCallback(result, dumpSignInResult)
        )
    }

    func changePassword(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let args = call.arguments as! [String: Any?]
        let oldPassword = args["oldPassword"] as! String
        let newPassword = args["newPassword"] as! String

        awsClient.changePassword(
            currentPassword: oldPassword,
            proposedPassword: newPassword,
            completionHandler: createErrorCallback(result)
        )
    }

    func forgotPassword(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let args = call.arguments as! [String: Any?]
        let username = args["username"] as! String

        awsClient.forgotPassword(
            username: username,
            completionHandler: createCallback(result, dumpForgotPasswordResult)
        )
    }

    func confirmForgotPassword(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
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
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
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
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        awsClient.getUserAttributes(completionHandler: self.createCallback(result))
    }

    func confirmUpdateUserAttribute(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let args = call.arguments as! [String: Any?]
        let attributeName = args["attributeName"] as! String
        let confirmationCode = args["confirmationCode"] as! String

        awsClient.confirmUpdateUserAttributes(
            attributeName: attributeName, code: confirmationCode,
            completionHandler: createErrorCallback(result)
        )
    }

    func signOut(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        awsClient.signOut()
        result(nil)
    }

    func getUsername(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        result(awsClient.username)
    }

    func isSignedIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        result(awsClient.isSignedIn)
    }

    func getIdentityId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        result(awsClient.identityId)
    }

    func currentUserState(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        result(dumpUserState(awsClient.currentUserState))
    }

    func getTokens(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        awsClient.getTokens(self.createCallback(result, dumpTokens))
    }

    func getCredentials(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        awsClient.getAWSCredentials(self.createCallback(result, dumpCredentials))
    }

    func federatedSignIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let args = call.arguments as! [String: Any?]
        let providerName = args["providerName"] as! String
        let token = args["token"] as! String

        awsClient.federatedSignIn(
            providerName: providerName,
            token: token,
            completionHandler: createCallback(result, dumpUserState)
        )
    }

    func showSignIn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let awsClient = self.awsClient else {
            result(notInitializedError)
            return
        }
        let navigationController = CognitoPluginAppDelegate.navigationController
        if navigationController == nil {
            let error = FlutterError(
                code: "UINavigationControllerNotFound",
                message: "This method cannot be called without access to a UINavigationController.\n" +
                    "Did you forget to replace `FlutterAppDelegate` with `CognitoPluginAppDelegate` in your app's AppDelegate.swift?",
                details: nil
            )
            result(error)
        } else {
            let args = call.arguments as! [String: Any?]
            let identityProvider = args["identityProvider"] as! String
            let scopes = args["scopes"] as! [String]

            // Optionally override the scopes based on the usecase.
            let hostedUIOptions = HostedUIOptions(scopes: scopes, identityProvider: identityProvider)

            // Present the Hosted UI sign in.
            awsClient.showSignIn(
                navigationController: navigationController!,
                hostedUIOptions: hostedUIOptions,
                createCallback(result, dumpUserState)
            )
        }
    }
}
