import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var returnValue;
  UserState userState;
  double progress;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final attrsController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmationCodeController = TextEditingController();

  Future<void> doLoad() async {
    var value;
    try {
      value = await Cognito.initialize();
    } catch (e, trace) {
      print(e);
      print(trace);

      if (!mounted) return;
      setState(() {
        returnValue = e;
        progress = -1;
      });

      return;
    }

    if (!mounted) return;
    setState(() {
      progress = -1;
      userState = value;
    });
  }

  @override
  void initState() {
    super.initState();
    doLoad();
    Cognito.registerCallback((value) {
      if (!mounted) return;
      setState(() {
        userState = value;
      });
    });
  }

  @override
  void dispose() {
    Cognito.registerCallback(null);
    super.dispose();
  }

  List<Widget> buildReturnValue() {
    return [
      Text(
        userState?.toString() ?? "UserState will appear here",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      Divider(
        color: Colors.black,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          returnValue?.toString() ?? "return values will appear here.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      )
    ];
  }

  // wraps a function from the auth library with some scaffold code.
  onPressWrapper(fn) {
    wrapper() async {
      setState(() {
        progress = null;
      });

      String value;
      try {
        value = (await fn()).toString();
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
        setState(() => value = e.toString());
      } finally {
        setState(() {
          progress = -1;
        });
      }

      setState(() => returnValue = value);
    }

    return wrapper;
  }

  textFields() {
    return [
      [
        TextField(
          decoration: InputDecoration(labelText: 'username'),
          controller: usernameController,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'password'),
          controller: passwordController,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'userAttributes'),
          controller: attrsController,
        )
      ],
      [
        TextField(
          decoration: InputDecoration(labelText: 'confirmationCode'),
          controller: confirmationCodeController,
        ),
      ],
      [
        TextField(
          decoration: InputDecoration(labelText: 'newPassword'),
          controller: newPasswordController,
        ),
      ],
    ];
  }

  signUp() {
    return [
      RaisedButton(
        child: Text("signUp(username, password)"),
        onPressed: onPressWrapper(() {
          final attrs = attrsController.text;
          return Cognito.signUp(
            usernameController.text,
            passwordController.text,
            attrs.isEmpty ? null : Map<String, String>.from(jsonDecode(attrs)),
          );
        }),
      ),
      RaisedButton(
        child: Text("confirmSignUp(username, confirmationCode)"),
        onPressed: onPressWrapper(() {
          return Cognito.confirmSignUp(
            usernameController.text,
            confirmationCodeController.text,
          );
        }),
      ),
      RaisedButton(
        child: Text("resendSignUp(username)"),
        onPressed: onPressWrapper(() {
          return Cognito.resendSignUp(usernameController.text);
        }),
      )
    ];
  }

  signIn() {
    return [
      RaisedButton(
        child: Text("signIn(username, password)"),
        onPressed: onPressWrapper(() {
          return Cognito.signIn(
            usernameController.text,
            passwordController.text,
          );
        }),
      ),
      RaisedButton(
        child: Text("confirmSignIn(confirmationCode)"),
        onPressed: onPressWrapper(() {
          return Cognito.confirmSignIn(confirmationCodeController.text);
        }),
      ),
      RaisedButton(
        child: Text("signOut()"),
        onPressed: onPressWrapper(() {
          return Cognito.signOut();
        }),
      ),
    ];
  }

  forgotPassword() {
    return [
      RaisedButton(
        child: Text("forgotPassword(username)"),
        onPressed: onPressWrapper(() {
          return Cognito.forgotPassword(usernameController.text);
        }),
      ),
      RaisedButton(
        child: Text(
          "confirmForgotPassword(username, newPassword, confirmationCode)",
        ),
        onPressed: onPressWrapper(() {
          return Cognito.confirmForgotPassword(
            usernameController.text,
            newPasswordController.text,
            confirmationCodeController.text,
          );
        }),
      )
    ];
  }

  utils() {
    return [
      RaisedButton(
        child: Text("getUsername()"),
        onPressed: onPressWrapper(() {
          return Cognito.getUsername();
        }),
      ),
      RaisedButton(
        child: Text("isSignedIn()"),
        onPressed: onPressWrapper(() {
          return Cognito.isSignedIn();
        }),
      ),
      RaisedButton(
        child: Text("getIdentityId()"),
        onPressed: onPressWrapper(() {
          return Cognito.getIdentityId();
        }),
      ),
      RaisedButton(
        child: Text("getTokens()"),
        onPressed: onPressWrapper(() {
          return Cognito.getTokens();
        }),
      ),
      RaisedButton(
        child: Text('getCredentials()'),
        onPressed: onPressWrapper(( ) {
          return Cognito.getCredentials();
        }
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AWS Cognito Sdk')),
        body: Stack(
          children: <Widget>[
            Center(
              child: buildChildren(
                <List<Widget>>[
                  buildReturnValue(),
                  ...textFields(),
                  signUp(),
                  signIn(),
                  forgotPassword(),
                  utils(),
                ],
              ),
            ),
            if (progress == null || progress > 0)
              Column(
                children: <Widget>[
                  LinearProgressIndicator(value: progress),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

Widget buildChildren(List<List<Widget>> children) {
  List<Widget> c = children.map((item) => Column(children: item)).toList();
  return ListView.separated(
    itemCount: children.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: c[index],
      );
    },
    separatorBuilder: (context, index) {
      return Container(color: Colors.purple[800], height: 2.5);
    },
  );
}
