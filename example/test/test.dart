import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cognito_plugin_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

class CognitoTest {
  final GlobalKey<MyAppState> appKey;

  CognitoTest(this.appKey);

  MyAppState get state => appKey.currentState;

  String get confirmationCode => state.confirmationCodeController.text;

  Future<void> waitForProgress() async {
    while (state.progress != -1) {
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<String> waitForConfirmationCode() async {
    state.confirmationCodeController.clear();
    while (confirmationCode.length < 6) {
      await Future.delayed(Duration(seconds: 1));
    }
    return confirmationCode;
  }

  Future<void> pressBtnWithKey(GlobalKey key) async {
    await (key.currentWidget as RaisedButton).onPressed();
    await waitForProgress();
  }

  Future<void> run() async {
    await waitForProgress();
    if (state.userState == UserState.SIGNED_IN) {
      await Cognito.signOut();
    }

    state.usernameController.text = "+918764022384";
    state.passwordController.text = "meghshala";

    await pressBtnWithKey(state.signInKey);

    print("Enter confirmation code!");
    final code = await waitForConfirmationCode();
    print("Got confirmation code: $code");


    await pressBtnWithKey(state.confirmSignInKey);


    print(find.text('getUsername').evaluate().first.widget);
  }
}

void main() {
  test('Cognito test', () async {
    final appKey = GlobalKey<MyAppState>();
    final app = MyApp(key: appKey);
    runApp(app);
    await CognitoTest(appKey).run();
  });
}
