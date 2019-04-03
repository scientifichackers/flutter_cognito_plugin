# Flutter Cognito Plugin

An AWS Cognito plugin for flutter. Supports both iOS and Android.

[![Sponsor](https://img.shields.io/badge/Sponsor-jaaga_labs-red.svg?style=for-the-badge)](https://www.jaaga.in/labs)

[![pub package](https://img.shields.io/pub/v/flutter_cognito_plugin.svg?style=for-the-badge)](https://pub.dartlang.org/packages/flutter_cognito_plugin)

## Installation

open `ios/Podfile` -- Ensure ios version is set to a minimum of `9.0`.
```podspec
platform :ios, '9.0'
```

Add an `awsconfiguration.json` file to `android/app/src/main/res/raw/awsconfiguration.json` and `ios/awsconfiguration.json`

This is typically what one looks like -

```json
{
  "Version": "1.0",
  "CredentialsProvider": {
    "CognitoIdentity": {
      "Default": {
        "PoolId": "REPLACE_ME",
        "Region": "REPLACE_ME"
      }
    }
  },
  "IdentityManager": {
    "Default": {}
  },
  "CognitoUserPool": {
    "Default": {
      "AppClientSecret": "REPLACE_ME",
      "AppClientId": "REPLACE_ME",
      "PoolId": "REPLACE_ME",
      "Region": "REPLACE_ME"
    }
  }
}
```


This plugin supports the amplify SDK for android and iOS,
and the the amplify cli can be used to generate the `awsconfiguration.json` file.

---

Now, just follow the regular flutter plugin installation on [Dart Pub](https://pub.dartlang.org/packages/flutter_cognito_plugin#-installing-tab-).

## Usage

The plugin comes with a showcase app that will let you try all features;
see if you setup the `awsconfiguration.json` correctly.

![Example Screenshot](https://i.imgur.com/5Lnl79O.png)

It's present in the usual `example` directory

```
$ git clone https://github.com/pycampers/flutter_cognito_plugin.git
$ cd flutter_cognito_plugin/example
$ flutter run
```