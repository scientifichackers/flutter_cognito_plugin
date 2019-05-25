[![Sponsor](https://img.shields.io/badge/Sponsor-jaaga_labs-red.svg?style=for-the-badge)](https://www.jaaga.in/labs)
[![pub package](https://img.shields.io/pub/v/flutter_cognito_plugin.svg?style=for-the-badge)](https://pub.dartlang.org/packages/flutter_cognito_plugin)

# Flutter Cognito Plugin

An AWS Cognito plugin for flutter. Supports both iOS and Android.

## Installation

First follow the regular flutter plugin installation on [Dart Pub](https://pub.dartlang.org/packages/flutter_cognito_plugin#-installing-tab-).

*Make sure you have built the app once for both Android/iOS before continuing.*

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

## Usage

The plugin comes with a showcase app that will let you try all features;
see if you setup the `awsconfiguration.json` correctly.

<image src='https://i.imgur.com/5Lnl79O.png' height=400 />

It's present in the usual `example` directory

```
$ git clone https://github.com/pycampers/flutter_cognito_plugin.git
$ cd flutter_cognito_plugin/example
$ flutter run
```
