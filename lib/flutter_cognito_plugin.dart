import 'package:flutter/services.dart';

/// Indicates who is responsible (if known) for a failed request.
///
/// For example, if a client is using an invalid AWS access key, the returned
/// exception will indicate that there is an error in the request the caller
/// is sending. Retrying that same request will *not* result in a successful
/// response. The Client ErrorType indicates that there is a problem in the
/// request the user is sending (ex: incorrect access keys, invalid parameter
/// value, missing parameter, etc.), and that the caller must take some
/// action to correct the request before it should be resent. Client errors
/// are typically associated an HTTP error code in the 4xx range.
///
/// The Service ErrorType indicates that although the request the caller sent
/// was valid, the service was unable to fulfill the request because of
/// problems on the service's side. These types of errors can be retried by
/// the caller since the caller's request was valid and the problem occurred
/// while processing the request on the service side. Service errors will be
/// accompanied by an HTTP error code in the 5xx range.
///
/// Finally, if there isn't enough information to determine who's fault the
/// error response is, an Unknown ErrorType will be set.
enum ErrorType { Client, Service, Unknown }

enum UserState {
  SIGNED_IN,
  GUEST,
  SIGNED_OUT_FEDERATED_TOKENS_INVALID,
  SIGNED_OUT_USER_POOLS_TOKENS_INVALID,
  SIGNED_OUT,
  UNKNOWN,
}

enum SignInState {
  /// Next challenge is to supply an SMS_MFA_CODE, delivered via SMS.
  SMS_MFA,

  /// Next challenge is to supply PASSWORD_CLAIM_SIGNATURE, PASSWORD_CLAIM_SECRET_BLOCK, and TIMESTAMP after the client-side SRP calculations.
  PASSWORD_VERIFIER,

  /// This is returned if your custom authentication flow determines that the user should pass another challenge before tokens are issued.
  CUSTOM_CHALLENGE,

  /// If device tracking was enabled on your user pool and the previous challenges were passed, this challenge is returned so that Amazon Cognito can start tracking this device.
  DEVICE_SRP_AUTH,

  /// Similar to PASSWORD_VERIFIER, but for devices only.
  DEVICE_PASSWORD_VERIFIER,

  /// This is returned if you need to authenticate with USERNAME and PASSWORD directly. An app client must be enabled to use this flow.
  ADMIN_NO_SRP_AUTH,

  /// For users which are required to change their passwords after successful first login. This challenge should be passed with NEW_PASSWORD and any other required attributes.
  NEW_PASSWORD_REQUIRED,

  /// The flow is completed and no further steps are possible.
  DONE,

  /// Unknown sign-in state, potentially unsupported state
  UNKNOWN
}

enum ForgotPasswordState { CONFIRMATION_CODE, DONE, UNKNOWN }

/// Determines where the confirmation code was sent.
class UserCodeDeliveryDetails {
  String attributeName;
  String destination;
  String deliveryMedium;

  @override
  String toString() {
    return "UserCodeDeliveryDetails("
        "attributeName=$attributeName, "
        "destination=$destination, "
        "deliveryMedium=$deliveryMedium)";
  }

  UserCodeDeliveryDetails.fromMsg(List msg) {
    if (msg.length != 3) return;
    attributeName = msg[0];
    destination = msg[1];
    deliveryMedium = msg[2];
  }
}

/// The result from signing-in. Check the state to determine the next step.
class SignInResult {
  SignInState signInState;

  /// Used to determine the type of challenge that is being present from the service
  Map<String, String> parameters;
  UserCodeDeliveryDetails userCodeDeliveryDetails;

  @override
  String toString() {
    return "SignInResult("
        "signInState=$signInState, "
        "parameters=$parameters, "
        "userCodeDeliveryDetails=$userCodeDeliveryDetails)";
  }

  SignInResult.fromMsg(List msg) {
    signInState = SignInState.values[msg[0]];
    parameters = (msg[1] == null) ? null : Map<String, String>.from(msg[1]);
    userCodeDeliveryDetails = UserCodeDeliveryDetails.fromMsg(msg.sublist(2));
  }
}

/// The result of a sign up action. Check the confirmation state and delivery details to proceed.
class SignUpResult {
  /// - [true] -> user is confirmed, no further action is necessary.
  /// - [false] -> check delivery details and call [confirmSignUp()].
  bool confirmationState;
  UserCodeDeliveryDetails userCodeDeliveryDetails;

  @override
  String toString() {
    return "SignUpResult("
        "confirmationState=$confirmationState, "
        "userCodeDeliveryDetails=$userCodeDeliveryDetails)";
  }

  SignUpResult.fromMsg(List msg) {
    confirmationState = msg[0];
    userCodeDeliveryDetails = UserCodeDeliveryDetails.fromMsg(msg.sublist(1));
  }
}

/// The result of a forgot password action
class ForgotPasswordResult {
  ForgotPasswordState state;
  UserCodeDeliveryDetails parameters;

  @override
  String toString() {
    return "ForgotPasswordResult(state=$state, parameters=$parameters)";
  }

  ForgotPasswordResult.fromMsg(List msg) {
    state = ForgotPasswordState.values[msg[0]];
    parameters = UserCodeDeliveryDetails.fromMsg(msg.sublist(1));
  }
}

/// Represents the state of the current user
class UserStateDetails {
  UserState userState;
  Map<String, String> details;

  @override
  String toString() {
    return "UserStateDetails(userState=$userState, details=$details)";
  }

  UserStateDetails.fromMsg(List msg) {
    userState = UserState.values[msg[0]];
    details = (msg[1] == null) ? null : Map<String, String>.from(msg[1]);
  }
}

const _platform = const MethodChannel('com.pycampers.fluttercognitoplugin');

typedef OnUserStateChange(UserStateDetails userState);

var _cognitoErrorRules = [
  ["ApolloException", "Failed to parse http response"],
  ["ApolloException", "Failed to execute http call"],
  ["com.amazonaws.AmazonClientException", "Unable to execute HTTP request"],
];

bool _satisfiesRules(PlatformException e) {
  for (var rule in _cognitoErrorRules) {
    if (e.code.toUpperCase().contains(rule[0].toUpperCase()) &&
        e.message.toUpperCase().contains(rule[1].toUpperCase())) {
      return true;
    }
  }
  return false;
}

class Cognito {
  /// The number of times to automatically retry sending a request.
  ///
  /// Useful for cases where network is flaky.
  ///
  /// Takes extra care to retry only for a network related error,
  /// and not a client error, like OTP incorrect, etc.
  ///
  /// 0 -> No retry.
  /// Non-zero number -> Retry specified number of times.
  /// null -> Infinite retry.
  static int autoRetryLimit = 0;

  /// The delay before retrying.
  static Duration retryDelay = Duration();

  /// Invokes a method with specified [MethodChannel] (platform).
  ///
  /// This is useful for other plugins that want
  /// to leverage the auto retry capabilities of this plugin.
  static Future<T> invokeMethodWithPlatform<T>(
    MethodChannel platform,
    String method, [
    dynamic arguments,
  ]) async {
    var tries = 0;
    while (true) {
      tries += 1;
      try {
        return await platform.invokeMethod<T>(method, arguments);
      } catch (e) {
        if (autoRetryLimit != null && tries > autoRetryLimit) {
          rethrow;
        }
        if (!(e is PlatformException)) {
          rethrow;
        }
        if (_satisfiesRules(e)) {
          print("[Cognito] Ignoring exception - $e");
          print(
            "[Cognito] Will retry after $retryDelay (tries: $tries, limit: $autoRetryLimit)",
          );
          await Future.delayed(retryDelay);
          continue;
        }
        rethrow;
      }
    }
  }

  static invokeMethod(String method, [dynamic arguments]) {
    return invokeMethodWithPlatform(_platform, method, arguments);
  }

  /// Initializes the AWS mobile client.
  ///
  /// This MUST be called before using any other methods under this class.
  /// A good strategy might be to invoke this before [runApp()] in [main()], like so:
  ///
  /// ```
  /// void main() async {
  ///   UserStateDetails details = await Cognito.initialize();
  ///   print(details);
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<UserStateDetails> initialize() async {
    return UserStateDetails.fromMsg(await invokeMethod("initialize"));
  }

  /// Registers a callback that gets called every-time the UserState changes.
  ///
  /// Replaces existing callback, if any.
  ///
  /// If `null` is passed, then the existing callback will be removed, if any.
  static void registerCallback(OnUserStateChange onUserStateChange) {
    if (onUserStateChange == null) {
      _platform.setMethodCallHandler(null);
      return;
    }

    _platform.setMethodCallHandler((call) {
      onUserStateChange(UserStateDetails.fromMsg(call.arguments));
    });
  }

  static Future<SignUpResult> signUp(
    String username,
    String password, [
    Map<String, dynamic> userAttributes,
  ]) async {
    return SignUpResult.fromMsg(
      await invokeMethod("signUp", {
        "username": username,
        "password": password,
        "userAttributes": userAttributes ?? {},
      }),
    );
  }

  static Future<SignUpResult> confirmSignUp(
    String username,
    String signUpChallengeResponse,
  ) async {
    return SignUpResult.fromMsg(
      await invokeMethod("confirmSignUp", {
        "username": username,
        "signUpChallengeResponse": signUpChallengeResponse,
      }),
    );
  }

  static Future<SignUpResult> resendSignUp(
    String username,
  ) async {
    return SignUpResult.fromMsg(
      await invokeMethod("resendSignUp", {
        "username": username,
      }),
    );
  }

  static Future<SignInResult> signIn(String username, String password) async {
    return SignInResult.fromMsg(
      await invokeMethod("signIn", {
        "username": username,
        "password": password,
      }),
    );
  }

  static Future<SignInResult> confirmSignIn(
    String signInChallengeResponse,
  ) async {
    return SignInResult.fromMsg(
      await invokeMethod("confirmSignIn", {
        "signInChallengeResponse": signInChallengeResponse,
      }),
    );
  }

  static Future<ForgotPasswordResult> forgotPassword(String username) async {
    return ForgotPasswordResult.fromMsg(
      await invokeMethod("forgotPassword", {
        "username": username,
      }),
    );
  }

  static Future<ForgotPasswordResult> confirmForgotPassword(
    String newPassword,
    String forgotPasswordChallengeResponse,
  ) async {
    return ForgotPasswordResult.fromMsg(
      await invokeMethod("confirmForgotPassword", {
        "newPassword": newPassword,
        "forgotPasswordChallengeResponse": forgotPasswordChallengeResponse,
      }),
    );
  }

  static Future<UserStateDetails> getUserStateDetails() async {
    return UserStateDetails.fromMsg(
      await invokeMethod("currentUserState"),
    );
  }

  static Future<void> signOut() async => await invokeMethod("signOut");

  static Future<String> getUsername() async {
    return await invokeMethod("getUsername");
  }

  static Future<bool> isSignedIn() async {
    return await invokeMethod("isSignedIn");
  }

  static Future<String> getIdentityId() async {
    return await invokeMethod("getIdentityId");
  }

  static Future<Map<String, dynamic>> getUserAttributes() async {
    return Map<String, dynamic>.from(
      await invokeMethod("getUserAttributes"),
    );
  }

  static Future<List<UserCodeDeliveryDetails>> updateUserAttributes(
    Map<String, dynamic> userAttributes,
  ) async {
    List uL = await invokeMethod("updateUserAttributes", {
      "userAttributes": userAttributes ?? {},
    });
    return List<UserCodeDeliveryDetails>.from(
      uL.map((u) => UserCodeDeliveryDetails.fromMsg(u)),
    );
  }

  static Future<void> confirmUpdateUserAttribute(
    String attributeName,
    String updateUserAttributeChallengeResponse,
  ) async {
    await invokeMethod("confirmUpdateUserAttribute", {
      "attributeName": attributeName,
      "updateUserAttributeChallengeResponse":
          updateUserAttributeChallengeResponse
    });
  }
}
