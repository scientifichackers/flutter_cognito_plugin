import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cognito_plugin/exceptions.dart';

var iosErrorMap = {
  "AWSMobileClientError.aliasExists": (m) => AliasExistsException(m),
  "AWSMobileClientError.codeDeliveryFailure": (m) =>
      CodeDeliveryFailureException(m),
  "AWSMobileClientError.codeMismatch": (m) => CodeMismatchException(m),
  "AWSMobileClientError.expiredCode": (m) => ExpiredCodeException(m),
  "AWSMobileClientError.groupExists": (m) => GroupExistsException(m),
  "AWSMobileClientError.internalError": (m) => InternalErrorException(m),
  "AWSMobileClientError.invalidLambdaResponse": (m) =>
      InvalidLambdaResponseException(m),
  "AWSMobileClientError.invalidOAuthFlow": (m) => InvalidOAuthFlowException(m),
  "AWSMobileClientError.invalidParameter": (m) => InvalidParameterException(m),
  "AWSMobileClientError.invalidPassword": (m) => InvalidPasswordException(m),
  "AWSMobileClientError.invalidUserPoolConfiguration": (m) =>
      InvalidUserPoolConfigurationException(m),
  "AWSMobileClientError.limitExceeded": (m) => LimitExceededException(m),
  "AWSMobileClientError.mfaMethodNotFound": (m) =>
      MfaMethodNotFoundException(m),
  "AWSMobileClientError.notAuthorized": (m) => NotAuthorizedException(m),
  "AWSMobileClientError.passwordResetRequired": (m) =>
      PasswordResetRequiredException(m),
  "AWSMobileClientError.resourceNotFound": (m) => ResourceNotFoundException(m),
  "AWSMobileClientError.scopeDoesNotExist": (m) =>
      ScopeDoesNotExistException(m),
  "AWSMobileClientError.softwareTokenMFANotFound": (m) =>
      SoftwareTokenMFANotFoundException(m),
  "AWSMobileClientError.tooManyFailedAttempts": (m) =>
      TooManyFailedAttemptsException(m),
  "AWSMobileClientError.tooManyRequests": (m) => TooManyRequestsException(m),
  "AWSMobileClientError.unexpectedLambda": (m) => UnexpectedLambdaException(m),
  "AWSMobileClientError.userLambdaValidation": (m) =>
      UserLambdaValidationException(m),
  "AWSMobileClientError.userNotConfirmed": (m) => UserNotConfirmedException(m),
  "AWSMobileClientError.userNotFound": (m) => UserNotFoundException(m),
  "AWSMobileClientError.usernameExists": (m) => UsernameExistsException(m),
  "AWSMobileClientError.unknown": (m) => UnknownException(m),
  "AWSMobileClientError.notSignedIn": (m) => NotSignedInException(m),
  "AWSMobileClientError.identityIdUnavailable": (m) =>
      IdentityIdUnavailableException(m),
  "AWSMobileClientError.guestAccessNotAllowed": (m) =>
      GuestAccessNotAllowedException(m),
  "AWSMobileClientError.federationProviderExists": (m) =>
      FederationProviderExistsException(m),
  "AWSMobileClientError.cognitoIdentityPoolNotConfigured": (m) =>
      CognitoIdentityPoolNotConfiguredException(m),
  "AWSMobileClientError.unableToSignIn": (m) => UnableToSignInException(m),
  "AWSMobileClientError.invalidState": (m) => InvalidStateException(m),
  "AWSMobileClientError.userPoolNotConfigured": (m) =>
      UserPoolNotConfiguredException(m),
  "AWSMobileClientError.userCancelledSignIn": (m) =>
      UserCancelledSignInException(m),
  "AWSMobileClientError.badRequest": (m) => BadRequestException(m),
  "AWSMobileClientError.expiredRefreshToken": (m) =>
      ExpiredRefreshTokenException(m),
  "AWSMobileClientError.errorLoadingPage": (m) => ErrorLoadingPageException(m),
  "AWSMobileClientError.securityFailed": (m) => SecurityFailedException(m),
  "AWSMobileClientError.idTokenNotIssued": (m) => IdTokenNotIssuedException(m),
  "AWSMobileClientError.idTokenAndAcceessTokenNotIssued": (m) =>
      IdTokenAndAccessTokenNotIssuedException(m),
  "AWSMobileClientError.invalidConfiguration": (m) =>
      InvalidConfigurationException(m),
  "AWSMobileClientError.deviceNotRemembered": (m) =>
      DeviceNotRememberedException(m),
};

var androidErrorMap = {
  "ApolloException": (m) => ApolloException(m),
  "com.amazonaws.AmazonClientException": (m) => AmazonClientException(m),
  "java.lang.IllegalStateException": (m) => InvalidStateException(m),
  //
  // below here, are generated
  //
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

Exception convertException(PlatformException _e) {
  var e;
  if (Platform.isAndroid) {
    e = androidErrorMap[_e.code](_e.message);
  } else if (Platform.isIOS) {
    e = iosErrorMap[_e.code](_e.message);
  }
  return e ?? _e;
}
