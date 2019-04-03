import Flutter
import UIKit

public class SwiftFlutterCognitoPlugin: NSObject, FlutterPlugin {
    let cognito = Cognito()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
                name: "com.pycampers.flutter_cognito_plugin",
                binaryMessenger: registrar.messenger()
        )
        let instance = SwiftFlutterCognitoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
            _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        cognito.callHandler(call: call, result: result)
    }
}
