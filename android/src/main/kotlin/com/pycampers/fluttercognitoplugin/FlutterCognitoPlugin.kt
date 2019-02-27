package com.pycampers.fluttercognitoplugin

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterCognitoPlugin {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(
              registrar.messenger(),
              "com.pycampers.fluttercognitoplugin"
      )
      channel.setMethodCallHandler(Cognito(registrar.context(), channel))
    }
  }
}
