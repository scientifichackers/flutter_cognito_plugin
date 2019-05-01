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

  Future<void> tapOnWidget(String text) async {
    testWidgets(description, callback)
    await find.text(text) 
  }

  Future<void> run() async {
    await waitForProgress();
    if (state.returnValue == UserState.SIGNED_IN) {
      await Cognito.signOut();
    }

    state.confirmSignupKey.currentState.
    print(result);

    print("Enter confirmation code!");
    final code = await waitForConfirmationCode();
    print("Got confirmation code: $code");
  }
}

void main() {
  test('Cognito test', () async {
    final appKey = GlobalKey<MyAppState>();
    final app = MyApp(key: appKey);
    runApp(app);
    CognitoTest(appKey).run();
  });
}
