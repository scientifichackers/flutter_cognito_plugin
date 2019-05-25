import Flutter
import plugin_scaffold
import UIKit

let pkgName = "com.pycampers.flutter_cognito_plugin"

public class SwiftFlutterCognitoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = Cognito()
        let channel = createPluginScaffold(
            messenger: registrar.messenger(),
            channelName: "com.pycampers.flutter_cognito_plugin",
            methodMap: [
                "initialize": plugin.initialize,
                "signUp": plugin.signUp,
                "confirmSignUp": plugin.confirmSignUp,
                "resendSignUp": plugin.resendSignUp,
                "signIn": plugin.signIn,
                "confirmSignIn": plugin.confirmSignIn,
                "forgotPassword": plugin.forgotPassword,
                "confirmForgotPassword": plugin.confirmForgotPassword,
                "signOut": plugin.signOut,
                "getUsername": plugin.getUsername,
                "isSignedIn": plugin.isSignedIn,
                "getIdentityId": plugin.getIdentityId,
                "currentUserState": plugin.currentUserState,
                "getUserAttributes": plugin.getUserAttributes,
                "updateUserAttributes": plugin.updateUserAttributes,
                "confirmUpdateUserAttribute": plugin.confirmUpdateUserAttribute,
                "getTokens": plugin.getTokens
            ]
        )
        plugin.awsClient.addUserStateListener("test" as NSString) { userState, _ in
            channel.invokeMethod("userStateCallback", arguments: dumpUserState(userState))
        }
    }
}
