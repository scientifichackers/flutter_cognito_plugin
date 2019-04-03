package com.pycampers.flutter_cognito_plugin

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterCognitoPlugin {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(
                    registrar.messenger(), "com.pycampers.flutter_cognito_plugin"
            )
            val cognito = Cognito(registrar.context(), channel)
            channel.setMethodCallHandler(cognito)
        }
    }
}
