package com.pycampers.flutter_cognito_plugin

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

const val CHANNEL_NAME = "com.pycampers.flutter_cognito_plugin"

class FlutterCognitoPlugin {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            val cognito = Cognito(registrar.context(), channel)
            channel.setMethodCallHandler(cognito)
        }
    }
}
