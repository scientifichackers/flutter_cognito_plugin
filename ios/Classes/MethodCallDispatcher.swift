import Flutter

class MethodCallDispatcher: NSObject {
    var result: FlutterResult? = nil
    var call: FlutterMethodCall? = nil
    var args: [String: Any]? = nil
    var methodName: String? = nil

    func callHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        self.call = call
        self.args = self.call?.arguments as? [String: Any]
        self.methodName = call.method
    
        let selector = Selector(call.method)
        if (self.responds(to: selector)) {
            self.perform(selector)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
