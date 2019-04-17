import Flutter

class MethodCallDispatcher: NSObject {

    class FlutterMethod: NSObject {
        let call: FlutterMethodCall
        let result: FlutterResult

        init(call: FlutterMethodCall, result: @escaping FlutterResult) {
            self.call = call
            self.result = result
        }

        var args: [String: Any] {
            return call.arguments as? [String: Any] ?? [:]
        }
    }

    func callHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {

        let selector = Selector("\(call.method):")
        if responds(to: selector) {
            perform(selector, with: FlutterMethod(call: call, result: result))
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
