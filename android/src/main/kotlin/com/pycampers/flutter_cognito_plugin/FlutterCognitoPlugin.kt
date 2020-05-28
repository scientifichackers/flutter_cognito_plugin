package com.pycampers.flutter_cognito_plugin

import android.content.Intent
import androidx.annotation.NonNull
import com.amazonaws.mobile.client.AWSMobileClient
import com.pycampers.plugin_scaffold.createPluginScaffold
import com.pycampers.plugin_scaffold.handler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar

const val PKG_NAME = "com.pycampers.flutter_cognito_plugin"

open class CognitoPluginActivity(val scheme: String) : FlutterActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (scheme == intent.data?.scheme) {
            AWSMobileClient.getInstance().handleAuthResponse(intent)
        }
    }
}

class FlutterCognitoPlugin : FlutterPlugin, ActivityAware {
    var plugin: Cognito? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        plugin = Cognito(flutterPluginBinding.applicationContext)
        val channel = createPluginScaffold(flutterPluginBinding.binaryMessenger, PKG_NAME, plugin!!)
        plugin!!.awsClient.addUserStateListener {
            handler.post {
                channel.invokeMethod("userStateCallback", dumpUserState(it))
            }
        }
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val plugin = Cognito(registrar.context())
            plugin.activity = registrar.activity()

            val channel = createPluginScaffold(registrar.messenger(), PKG_NAME, plugin)
            plugin.awsClient.addUserStateListener {
                handler.post {
                    channel.invokeMethod("userStateCallback", dumpUserState(it))
                }
            }
        }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        plugin?.activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        plugin?.activity = binding.activity
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}
    override fun onDetachedFromActivity() {}
    override fun onDetachedFromActivityForConfigChanges() {}
}
