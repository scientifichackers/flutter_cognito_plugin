package com.pycampers.flutter_cognito_plugin

import com.pycampers.plugin_scaffold.createPluginScaffold
import io.flutter.plugin.common.PluginRegistry.Registrar

const val PKG_NAME = "com.pycampers.flutter_cognito_plugin"

class FlutterCognitoPlugin {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val cognito = Cognito(registrar.context())
            val channel = createPluginScaffold(registrar.messenger(), PKG_NAME, cognito)
            cognito.awsClient.addUserStateListener {
                channel.invokeMethod("userStateCallback", dumpUserState(it))
            }
        }
    }
}
