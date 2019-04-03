import AWSMobileClient
import Flutter

class Cognito: MethodCallDispatcher {
    let awsClient = AWSMobileClient.sharedInstance()

    func awsCallback<T>(_ obj: T?, _ error: Error?, _ dumpObj: (T) -> Any) {
        if let obj = obj {
            self.result!(dumpObj(obj))
        } else if let error = error {
            self.result!(dumpError(error))
        } else {
            self.result!(nil)
        }
    }

    @objc func initialize() {
        awsClient.initialize { (userState, error) in
            self.awsCallback(userState, error, dumpUserState)
        }
    }

    @objc func signUp() {
        let username = self.args!["username"] as! String
        let password = self.args!["password"] as! String
        let attrs = self.args!["userAttributes"] as! [String: String]

        awsClient.signUp(
                username: username,
                password: password,
                userAttributes: attrs,
                validationData: [:]
        ) { (result, error) in
            self.awsCallback(result, error, dumpSignUpResult)
        }
    }

    @objc func confirmSignUp() {
        let username = self.args!["username"] as! String
        let confirmationCode = self.args!["confirmationCode"] as! String

        awsClient.confirmSignUp(
                username: username,
                confirmationCode: confirmationCode
        ) { (result, error) in
            self.awsCallback(result, error, dumpSignUpResult)
        }
    }

    @objc func resendSignUp() {
        let username = self.args!["username"] as! String

        awsClient.resendSignUpCode(
                username: username
        ) { (result, error) in
            self.awsCallback(result, error, dumpSignUpResult)
        }
    }

    @objc func signIn() {
        let username = self.args!["username"] as! String
        let password = self.args!["password"] as! String

        awsClient.signIn(
                username: username, password: password
        ) { (result, error) in
            self.awsCallback(result, error, dumpSignInResult)
        }
    }

    @objc func confirmSignIn() {
        let confirmationCode = self.args!["confirmationCode"] as! String

        awsClient.confirmSignIn(
                challengeResponse: confirmationCode
        ) { (result, error) in
            self.awsCallback(result, error, dumpSignInResult)
        }
    }

    @objc func forgotPassword() {
        let username = self.args!["username"] as! String

        awsClient.forgotPassword(username: username) { (result, error) in
            self.awsCallback(result, error, dumpForgotPasswordResult)
        }
    }

    @objc func confirmForgotPassword() {
        let username = self.args!["username"] as! String
        let newPassword = self.args!["newPassword"] as! String
        let confirmationCode = self.args!["confirmationCode"] as! String

        awsClient.confirmForgotPassword(
                username: username,
                newPassword: newPassword,
                confirmationCode: confirmationCode
        ) { (result, error) in
            self.awsCallback(result, error, dumpForgotPasswordResult)
        }
    }

    @objc func signOut() {
        awsClient.signOut()
        self.result!(nil)
    }

    @objc func getUsername() {
        self.result!(awsClient.username)
    }

    @objc func isSignedIn() {
        self.result!(awsClient.isSignedIn)
    }

    @objc func getIdentityId() {
        self.result!(awsClient.identityId)
    }

    @objc func currentUserState() {
        self.result!(awsClient.currentUserState)
    }

    @objc func getUserAttributes() {
        awsClient.getUserAttributes { (result, error) in
            self.awsCallback(result, error, { (attrs) -> Any in
                return attrs
            })
        }
    }

    @objc func updateUserAttributes() {
        let userAttributes = self.args!["userAttributes"] as! [String: String]

        awsClient.updateUserAttributes(
                attributeMap: userAttributes
        ) { (result, error) in
            self.awsCallback(result, error, { (u) -> Any in
                return u.map({ (it) -> Any in
                    dumpUserCodeDeliveryDetails(it)
                })
            })
        }
    }

    @objc func confirmUpdateUserAttribute() {
        let attributeName = self.args!["attributeName"] as! String
        let confirmationCode = self.args!["confirmationCode"] as! String

        awsClient.confirmUpdateUserAttributes(
                attributeName: attributeName, code: confirmationCode
        ) { (error) in
            if let error = error {
                self.result!(dumpError(error))
            } else {
                self.result!(nil)
            }
        }
    }
}
