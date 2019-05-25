import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cognito_plugin/exceptions.dart';

final _iosErrors = {
  "aliasExists": (m) => AliasExistsException(m),
  "codeDeliveryFailure": (m) => CodeDeliveryFailureException(m),
  "codeMismatch": (m) => CodeMismatchException(m),
  "expiredCode": (m) => ExpiredCodeException(m),
  "groupExists": (m) => GroupExistsException(m),
  "internalError": (m) => InternalErrorException(m),
  "invalidLambdaResponse": (m) => InvalidLambdaResponseException(m),
  "invalidOAuthFlow": (m) => InvalidOAuthFlowException(m),
  "invalidParameter": (m) => InvalidParameterException(m),
  "invalidPassword": (m) => InvalidPasswordException(m),
  "invalidUserPoolConfiguration": (m) =>
      InvalidUserPoolConfigurationException(m),
  "limitExceeded": (m) => LimitExceededException(m),
  "mfaMethodNotFound": (m) => MfaMethodNotFoundException(m),
  "notAuthorized": (m) => NotAuthorizedException(m),
  "passwordResetRequired": (m) => PasswordResetRequiredException(m),
  "resourceNotFound": (m) => ResourceNotFoundException(m),
  "scopeDoesNotExist": (m) => ScopeDoesNotExistException(m),
  "softwareTokenMFANotFound": (m) => SoftwareTokenMFANotFoundException(m),
  "tooManyFailedAttempts": (m) => TooManyFailedAttemptsException(m),
  "tooManyRequests": (m) => TooManyRequestsException(m),
  "unexpectedLambda": (m) => UnexpectedLambdaException(m),
  "userLambdaValidation": (m) => UserLambdaValidationException(m),
  "userNotConfirmed": (m) => UserNotConfirmedException(m),
  "userNotFound": (m) => UserNotFoundException(m),
  "usernameExists": (m) => UsernameExistsException(m),
  "unknown": (m) => UnknownException(m),
  "notSignedIn": (m) => NotSignedInException(m),
  "identityIdUnavailable": (m) => IdentityIdUnavailableException(m),
  "guestAccessNotAllowed": (m) => GuestAccessNotAllowedException(m),
  "federationProviderExists": (m) => FederationProviderExistsException(m),
  "cognitoIdentityPoolNotConfigured": (m) =>
      CognitoIdentityPoolNotConfiguredException(m),
  "unableToSignIn": (m) => UnableToSignInException(m),
  "invalidState": (m) => InvalidStateException(m),
  "userPoolNotConfigured": (m) => UserPoolNotConfiguredException(m),
  "userCancelledSignIn": (m) => UserCancelledSignInException(m),
  "badRequest": (m) => BadRequestException(m),
  "expiredRefreshToken": (m) => ExpiredRefreshTokenException(m),
  "errorLoadingPage": (m) => ErrorLoadingPageException(m),
  "securityFailed": (m) => SecurityFailedException(m),
  "idTokenNotIssued": (m) => IdTokenNotIssuedException(m),
  "idTokenAndAcceessTokenNotIssued": (m) =>
      IdTokenAndAccessTokenNotIssuedException(m),
  "invalidConfiguration": (m) => InvalidConfigurationException(m),
  "deviceNotRemembered": (m) => DeviceNotRememberedException(m),
};

final _androidErrors = {
  "AliasExistsException": (m) => AliasExistsException(m),
  "CodeDeliveryFailureException": (m) => CodeDeliveryFailureException(m),
  "CodeMismatchException": (m) => CodeMismatchException(m),
  "ExpiredCodeException": (m) => ExpiredCodeException(m),
  "GroupExistsException": (m) => GroupExistsException(m),
  "InternalErrorException": (m) => InternalErrorException(m),
  "InvalidLambdaResponseException": (m) => InvalidLambdaResponseException(m),
  "InvalidOAuthFlowException": (m) => InvalidOAuthFlowException(m),
  "InvalidParameterException": (m) => InvalidParameterException(m),
  "InvalidPasswordException": (m) => InvalidPasswordException(m),
  "InvalidUserPoolConfigurationException": (m) =>
      InvalidUserPoolConfigurationException(m),
  "LimitExceededException": (m) => LimitExceededException(m),
  "MfaMethodNotFoundException": (m) => MfaMethodNotFoundException(m),
  "NotAuthorizedException": (m) => NotAuthorizedException(m),
  "PasswordResetRequiredException": (m) => PasswordResetRequiredException(m),
  "ResourceNotFoundException": (m) => ResourceNotFoundException(m),
  "ScopeDoesNotExistException": (m) => ScopeDoesNotExistException(m),
  "SoftwareTokenMFANotFoundException": (m) =>
      SoftwareTokenMFANotFoundException(m),
  "TooManyFailedAttemptsException": (m) => TooManyFailedAttemptsException(m),
  "TooManyRequestsException": (m) => TooManyRequestsException(m),
  "UnexpectedLambdaException": (m) => UnexpectedLambdaException(m),
  "UserLambdaValidationException": (m) => UserLambdaValidationException(m),
  "UserNotConfirmedException": (m) => UserNotConfirmedException(m),
  "UserNotFoundException": (m) => UserNotFoundException(m),
  "UsernameExistsException": (m) => UsernameExistsException(m),
  "UnknownException": (m) => UnknownException(m),
  "NotSignedInException": (m) => NotSignedInException(m),
  "IdentityIdUnavailableException": (m) => IdentityIdUnavailableException(m),
  "GuestAccessNotAllowedException": (m) => GuestAccessNotAllowedException(m),
  "FederationProviderExistsException": (m) =>
      FederationProviderExistsException(m),
  "CognitoIdentityPoolNotConfiguredException": (m) =>
      CognitoIdentityPoolNotConfiguredException(m),
  "UnableToSignInException": (m) => UnableToSignInException(m),
  "InvalidStateException": (m) => InvalidStateException(m),
  "UserPoolNotConfiguredException": (m) => UserPoolNotConfiguredException(m),
  "UserCancelledSignInException": (m) => UserCancelledSignInException(m),
  "BadRequestException": (m) => BadRequestException(m),
  "ExpiredRefreshTokenException": (m) => ExpiredRefreshTokenException(m),
  "ErrorLoadingPageException": (m) => ErrorLoadingPageException(m),
  "SecurityFailedException": (m) => SecurityFailedException(m),
  "IdTokenNotIssuedException": (m) => IdTokenNotIssuedException(m),
  "IdTokenAndAcceessTokenNotIssuedException": (m) =>
      IdTokenAndAccessTokenNotIssuedException(m),
  "InvalidConfigurationException": (m) => InvalidConfigurationException(m),
  "DeviceNotRememberedException": (m) => DeviceNotRememberedException(m),
};

const _iosErrorPrefix = 'AWSMobileClientError.';
const _androidErrorPrefix =
    'com.amazonaws.services.cognitoidentityprovider.model.';

var _errorMap;

void _initialize() {
  if (Platform.isAndroid) {
    _errorMap = _androidErrors.map((k, v) {
      return MapEntry(_androidErrorPrefix + k, v);
    });
    _errorMap.addAll({
      "com.amazonaws.AmazonClientException": (m) => AmazonClientException(m),
      "java.lang.IllegalStateException": (m) => InvalidStateException(m),
      "java.lang.RuntimeException": (m) => RuntimeException(m),
    });
  } else {
    _errorMap = _iosErrors.map((k, v) {
      return MapEntry(_iosErrorPrefix + k, v);
    });
  }
}

CognitoException tryConvertException(PlatformException e) {
  if (_errorMap == null) _initialize();
  CognitoException ce;
  if (Platform.isAndroid) {
    ce = _androidErrors[e.code]?.call(e.message);
  } else if (Platform.isIOS) {
    ce = _iosErrors[e.code]?.call(e.message);
  }
  return ce;
}
