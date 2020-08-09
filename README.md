[![Sponsor](https://img.shields.io/badge/Sponsor-jaaga_labs-red.svg?style=for-the-badge)](https://www.jaaga.in/labs)
[![pub package](https://img.shields.io/pub/v/flutter_cognito_plugin.svg?style=for-the-badge)](https://pub.dartlang.org/packages/flutter_cognito_plugin)

# Flutter Cognito Plugin

An AWS Cognito plugin for flutter. Supports both iOS and Android.

## Installation

First follow the regular flutter plugin installation on [Dart Pub](https://pub.dartlang.org/packages/flutter_cognito_plugin#-installing-tab-).

_Make sure you have built the app once for both Android/iOS before continuing._

---

Since this plugin uses the native AWS sdk, the installation is a little more involved.

### Android

Add an `awsconfiguration.json` file to `android/app/src/main/res/raw/awsconfiguration.json`.

This is what one should look like :-

```json
{
    "IdentityManager": {
        "Default": {}
    },
    "CredentialsProvider": {
        "CognitoIdentity": {
            "Default": {
                "PoolId": "XX-XXXX-X:XXXXXXXX-XXXX-1234-abcd-1234567890ab",
                "Region": "XX-XXXX-X"
            }
        }
    },
    "CognitoUserPool": {
        "Default": {
            "PoolId": "XX-XXXX-X_abcd1234",
            "AppClientId": "XXXXXXXX",
            "AppClientSecret": "XXXXXXXXX",
            "Region": "XX-XXXX-X"
        }
    }
}
```

This plugin supports the amplify SDK for android and iOS,
and the the amplify cli can be used to generate the `awsconfiguration.json` file.

Just do `$ amplify init` from the `android` & `ios` folder of your app.

### iOS

Run `$ pod init` from the `ios` folder of your app.

Now, open `ios/Podfile`. Ensure ios version is set to a minimum of `9.0`.

```podspec
platform :ios, '9.0'
```

To add the `awsconfiguration.json` file to iOS module, you will unfortunately,
need to open up your project in XCode.

1. Start Xcode
2. Click on ‘File > Open’
3. Select the `ios/Runner.xcworkspace` file.

Now just drag-drop the `awsconfiguration.json` file, from `android/app/src/main/res/raw/awsconfiguration.json` to XCode Runner (Right next to `AppDelegate.swift`).

[Here](https://i.imgur.com/tAXQuQ3.mp4) is a video.

That should create a symlink to the file in the ios module, and bundle it into the final ios app.

This way you won't need to maintain 2 config files.

## Hosted UI

The [Hosted UI](https://docs.amplify.aws/sdk/auth/hosted-ui/q/platform/android) feature is needed for using Social login.
Unfortunately, this requires you to modify native code in your app.

First, add the following section to `android/app/src/main/res/raw/awsconfiguration.json` -

(`"myapp://callback"` and `"myapp://signout"` are custom urls you can provide in the "App client settings" section of Cognito User Pools)

```
{
  ...

  "Auth": {
    "Default": {
      "OAuth": {
        "WebDomain": "XXX.auth.ap-south-1.amazoncognito.com",
        "AppClientId": "XXXXXXXX",
        "AppClientSecret": "XXXXX"
        "SignInRedirectURI": "myapp://callback",
        "SignOutRedirectURI": "myapp://signout",
        "Scopes": ["email, "openid"]
      }
    }
  }
}
```

### Android

1. Open your app's [`andorid/app/src/main/com/kotlin/.../MainActivity.kt`](example/android/app/src/main/kotlin/com/pycampers/flutter_cognito_plugin_example/MainActivity.kt)
   and replace `FlutterActivity()` by `CognitoPluginActivity("<url scheme>")`.

Here's what it should look like -

```kotlin
package ...

import androidx.annotation.NonNull
import com.pycampers.flutter_cognito_plugin.CognitoPluginActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : CognitoPluginActivity("myapp") {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
```

2. Add the following to [`android/app/src/main/AndroidManifest.xml`](example/android/app/src/main/AndroidManifest.xml) -

```xml
<manifest ...>
        <application ...>
            ...

            <!-- Add this section for AWS Cognito hosted UI-->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />

                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />

                <data android:scheme="myapp" />
            </intent-filter>

        </application>
</manifest>
```

### iOS

1. Open you apps's [`ios/Runner/AppDelegate.swift`](example/ios/Runner/AppDelegate.swift),
   and replace `FlutterAppDelegate` with `CognitoPluginAppDelegate`.

Here's what it should look like -

```swift
import Flutter
import flutter_cognito_plugin
import UIKit

@UIApplicationMain
@objc class AppDelegate: CognitoPluginAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

2. Add the following to [`ios/Runner/Info.plist`](example/ios/Runner/Info.plist)

```
<plist version="1.0">
<dict>
    <!-- YOUR OTHER PLIST ENTRIES HERE -->

    <!-- ADD AN ENTRY TO CFBundleURLTypes for Cognito Auth -->
    <!-- IF YOU DO NOT HAVE CFBundleURLTypes, YOU CAN COPY THE WHOLE BLOCK BELOW -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>myapp</string>
            </array>
        </dict>
    </array>
</dict>
</array>

<!-- ... -->
</dict>
```

### Dart

Once the native setup is complete, you can use the following in your flutter app to launch the Hosted UI -

```dart
Cognito.showSignIn(
  identityProvider: "Cognito",
  scopes: ["email", "openid"],
);
```

## Usage

The plugin comes with a showcase app that will let you try all features --
given that you setup the `awsconfiguration.json` correctly.

<image src='https://i.imgur.com/5Lnl79O.png' height=400 />

It's present in the usual [`example`](https://github.com/scientifichackers/flutter_cognito_plugin/blob/master/example/lib/main.dart) directory

```
$ git clone https://github.com/pycampers/flutter_cognito_plugin.git
$ cd flutter_cognito_plugin/example
$ flutter run
```

## AppSync

You can use AWS AppSync GraphQL API using this plugin easily. Just pass in the query as a String, and the query variables!

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:http/http.dart' as http;


static Future<Map> query(
  String query,
  Map<String, dynamic> variables,
) async {
  final tokens = await Cognito.getTokens();

  final response = await http.post(
    graphQLEndpoint,
    headers: {
      HttpHeaders.authorizationHeader: tokens.accessToken,
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    },
    body: jsonEncode({
      "query": query,
      "variables": variables,
    }),
  );

  if (response.statusCode == HttpStatus.ok) {
    return jsonDecode(response.body);
  }

  print(
    "http request failed! { statusCode: ${response.statusCode}, body: ${response.body} }",
  );
  return null;
}
```
