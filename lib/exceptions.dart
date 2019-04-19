import 'package:flutter/services.dart';

class CognitoException implements Exception {
  String message;

  CognitoException(this.message);

  @override
  String toString() {
    return "$runtimeType: $message";
  }
}

class AliasExistsException extends CognitoException {
  AliasExistsException(String message) : super(message);
}

class CodeDeliveryFailureException extends CognitoException {
  CodeDeliveryFailureException(String message) : super(message);
}

class CodeMismatchException extends CognitoException {
  CodeMismatchException(String message) : super(message);
}

class ExpiredCodeException extends CognitoException {
  ExpiredCodeException(String message) : super(message);
}

class GroupExistsException extends CognitoException {
  GroupExistsException(String message) : super(message);
}

class InternalErrorException extends CognitoException {
  InternalErrorException(String message) : super(message);
}

class InvalidLambdaResponseException extends CognitoException {
  InvalidLambdaResponseException(String message) : super(message);
}

class InvalidOAuthFlowException extends CognitoException {
  InvalidOAuthFlowException(String message) : super(message);
}

class InvalidParameterException extends CognitoException {
  InvalidParameterException(String message) : super(message);
}

class InvalidPasswordException extends CognitoException {
  InvalidPasswordException(String message) : super(message);
}

class InvalidUserPoolConfigurationException extends CognitoException {
  InvalidUserPoolConfigurationException(String message) : super(message);
}

class LimitExceededException extends CognitoException {
  LimitExceededException(String message) : super(message);
}

class MfaMethodNotFoundException extends CognitoException {
  MfaMethodNotFoundException(String message) : super(message);
}

class NotAuthorizedException extends CognitoException {
  NotAuthorizedException(String message) : super(message);
}

class PasswordResetRequiredException extends CognitoException {
  PasswordResetRequiredException(String message) : super(message);
}

class ResourceNotFoundException extends CognitoException {
  ResourceNotFoundException(String message) : super(message);
}

class ScopeDoesNotExistException extends CognitoException {
  ScopeDoesNotExistException(String message) : super(message);
}

class SoftwareTokenMFANotFoundException extends CognitoException {
  SoftwareTokenMFANotFoundException(String message) : super(message);
}

class TooManyFailedAttemptsException extends CognitoException {
  TooManyFailedAttemptsException(String message) : super(message);
}

class TooManyRequestsException extends CognitoException {
  TooManyRequestsException(String message) : super(message);
}

class UnexpectedLambdaException extends CognitoException {
  UnexpectedLambdaException(String message) : super(message);
}

class UserLambdaValidationException extends CognitoException {
  UserLambdaValidationException(String message) : super(message);
}

class UserNotConfirmedException extends CognitoException {
  UserNotConfirmedException(String message) : super(message);
}

class UserNotFoundException extends CognitoException {
  UserNotFoundException(String message) : super(message);
}

class UsernameExistsException extends CognitoException {
  UsernameExistsException(String message) : super(message);
}

class UnknownException extends CognitoException {
  UnknownException(String message) : super(message);
}

class NotSignedInException extends CognitoException {
  NotSignedInException(String message) : super(message);
}

class IdentityIdUnavailableException extends CognitoException {
  IdentityIdUnavailableException(String message) : super(message);
}

class GuestAccessNotAllowedException extends CognitoException {
  GuestAccessNotAllowedException(String message) : super(message);
}

class FederationProviderExistsException extends CognitoException {
  FederationProviderExistsException(String message) : super(message);
}

class CognitoIdentityPoolNotConfiguredException extends CognitoException {
  CognitoIdentityPoolNotConfiguredException(String message) : super(message);
}

class UnableToSignInException extends CognitoException {
  UnableToSignInException(String message) : super(message);
}

class InvalidStateException extends CognitoException {
  InvalidStateException(String message) : super(message);
}

class UserPoolNotConfiguredException extends CognitoException {
  UserPoolNotConfiguredException(String message) : super(message);
}

class UserCancelledSignInException extends CognitoException {
  UserCancelledSignInException(String message) : super(message);
}

class BadRequestException extends CognitoException {
  BadRequestException(String message) : super(message);
}

class ExpiredRefreshTokenException extends CognitoException {
  ExpiredRefreshTokenException(String message) : super(message);
}

class ErrorLoadingPageException extends CognitoException {
  ErrorLoadingPageException(String message) : super(message);
}

class SecurityFailedException extends CognitoException {
  SecurityFailedException(String message) : super(message);
}

class IdTokenNotIssuedException extends CognitoException {
  IdTokenNotIssuedException(String message) : super(message);
}

class IdTokenAndAccessTokenNotIssuedException extends CognitoException {
  IdTokenAndAccessTokenNotIssuedException(String message) : super(message);
}

class InvalidConfigurationException extends CognitoException {
  InvalidConfigurationException(String message) : super(message);
}

class DeviceNotRememberedException extends CognitoException {
  DeviceNotRememberedException(String message) : super(message);
}

class AmazonClientException extends CognitoException {
  AmazonClientException(String message) : super(message);
}

class ApolloException extends CognitoException {
  ApolloException(String message) : super(message);
}

class RuntimeException extends CognitoException {
  RuntimeException(String message) : super(message);
}
