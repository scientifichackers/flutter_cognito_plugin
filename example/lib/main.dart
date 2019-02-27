import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter/material.dart';

void main() async {
  var details = await Cognito.initialize();
  runApp(MyApp(details));
}

class MyApp extends StatefulWidget {
  final UserStateDetails userStateDetails;

  MyApp(this.userStateDetails);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _userStateDetails;

  @override
  void initState() {
    _userStateDetails = widget.userStateDetails.toString();
    super.initState();
    Cognito.registerCallback((details) {
      if (mounted) {
        setState(() {
          _userStateDetails = details.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    Cognito.registerCallback(null);
    super.dispose();
  }

  String _returnValue;

  returnValue() {
    return [
      Text(
        _userStateDetails ?? "currentUserState() will appear here",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      Divider(
        color: Colors.black,
      ),
      Text(
        _returnValue ?? "return values will appear here.",
        style: TextStyle(fontStyle: FontStyle.italic),
      )
    ];
  }

  String _username;
  String _password;

  double _progress = -1;

  // wraps a function from the auth library with some scaffold code.
  onPressWrapper(fn) {
    wrapper() async {
      setState(() {
        _progress = null;
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
          _progress = -1;
        });
      }

      setState(() => _returnValue = value.toString());
    }

    return wrapper;
  }

  textFields() {
    return [
      [
        TextField(
          decoration: InputDecoration(labelText: 'username'),
          onChanged: (value) {
            setState(() => _username = value);
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'password'),
          onChanged: (value) {
            setState(() => _password = value);
          },
        )
      ],
      [
        TextField(
          decoration: InputDecoration(labelText: "signInChallengeResponse"),
          onChanged: (value) {
            setState(() => _signInChallengeResponse = value);
          },
        )
      ],
      [
        TextField(
          decoration: InputDecoration(labelText: 'signUpChallengeResponse'),
          onChanged: (value) =>
              setState(() => _signUpChallengeResponse = value),
        )
      ],
      [
        TextField(
          decoration: InputDecoration(labelText: 'newPassword'),
          onChanged: (value) {
            setState(() => _newPassword = value);
          },
        ),
        TextField(
          decoration:
          InputDecoration(labelText: 'forgotPasswordChallengeResponse'),
          onChanged: (value) {
            setState(() => _forgotPasswordChallengeResponse = value);
          },
        )
      ],
    ];
  }

  String _signUpChallengeResponse;

  signUp() {
    return [
      RaisedButton(
        child: Text("signUp(username, password)"),
        onPressed: onPressWrapper(() {
          return Cognito.signUp(_username, _password);
        }),
      ),
      RaisedButton(
        child: Text("confirmSignUp(username, signUpChallengeResponse)"),
        onPressed: onPressWrapper(() {
          return Cognito.confirmSignUp(_username, _signUpChallengeResponse);
        }),
      ),
      RaisedButton(
        child: Text("resendSignUp(username)"),
        onPressed: onPressWrapper(() {
          return Cognito.resendSignUp(_username);
        }),
      )
    ];
  }

  String _signInChallengeResponse;

  signIn() {
    return [
      RaisedButton(
        child: Text("signIn(username, password)"),
        onPressed: onPressWrapper(() {
          return Cognito.signIn(_username, _password);
        }),
      ),
      RaisedButton(
        child: Text("confirmSignIn(signInChallengeResponse)"),
        onPressed: onPressWrapper(() {
          return Cognito.confirmSignIn(_signInChallengeResponse);
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

  String _newPassword;
  String _forgotPasswordChallengeResponse;

  forgotPassword() {
    return [
      RaisedButton(
        child: Text("forgotPassword(username)"),
        onPressed: onPressWrapper(() {
          return Cognito.forgotPassword(_username);
        }),
      ),
      RaisedButton(
        child: Text(
          "confirmForgotPassword(newPassword, forgotPasswordChallengeResponse)",
        ),
        onPressed: onPressWrapper(() {
          return Cognito.confirmForgotPassword(
              _newPassword, _forgotPasswordChallengeResponse);
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
                <List<Widget>>[returnValue()] +
                    textFields() +
                    <List<Widget>>[
                      signUp(),
                      signIn(),
                      forgotPassword(),
                      utils(),
                    ],
              ),
            ),
            (_progress == null || _progress > 0)
                ? Column(
              children: <Widget>[
                LinearProgressIndicator(value: _progress),
              ],
            )
                : Container(),
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
