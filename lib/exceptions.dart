class CognitoException implements Exception {
  String message, details;

  CognitoException(this.message, this.details);

  @override
  String toString() {
    return "$runtimeType: $message\n$details";
  }
}

class AliasExistsException extends CognitoException {
  AliasExistsException(String message, String details)
      : super(message, details);
}

class CodeDeliveryFailureException extends CognitoException {
  CodeDeliveryFailureException(String message, String details)
      : super(message, details);
}

class CodeMismatchException extends CognitoException {
  CodeMismatchException(String message, String details)
      : super(message, details);
}

class ExpiredCodeException extends CognitoException {
  ExpiredCodeException(String message, String details)
      : super(message, details);
}

class GroupExistsException extends CognitoException {
  GroupExistsException(String message, String details)
      : super(message, details);
}

class InternalErrorException extends CognitoException {
  InternalErrorException(String message, String details)
      : super(message, details);
}

class InvalidLambdaResponseException extends CognitoException {
  InvalidLambdaResponseException(String message, String details)
      : super(message, details);
}

class InvalidOAuthFlowException extends CognitoException {
  InvalidOAuthFlowException(String message, String details)
      : super(message, details);
}

class InvalidParameterException extends CognitoException {
  InvalidParameterException(String message, String details)
      : super(message, details);
}

class InvalidPasswordException extends CognitoException {
  InvalidPasswordException(String message, String details)
      : super(message, details);
}

class InvalidUserPoolConfigurationException extends CognitoException {
  InvalidUserPoolConfigurationException(String message, String details)
      : super(message, details);
}

class LimitExceededException extends CognitoException {
  LimitExceededException(String message, String details)
      : super(message, details);
}

class MfaMethodNotFoundException extends CognitoException {
  MfaMethodNotFoundException(String message, String details)
      : super(message, details);
}

class NotAuthorizedException extends CognitoException {
  NotAuthorizedException(String message, String details)
      : super(message, details);
}

class PasswordResetRequiredException extends CognitoException {
  PasswordResetRequiredException(String message, String details)
      : super(message, details);
}

class ResourceNotFoundException extends CognitoException {
  ResourceNotFoundException(String message, String details)
      : super(message, details);
}

class ScopeDoesNotExistException extends CognitoException {
  ScopeDoesNotExistException(String message, String details)
      : super(message, details);
}

class SoftwareTokenMFANotFoundException extends CognitoException {
  SoftwareTokenMFANotFoundException(String message, String details)
      : super(message, details);
}

class TooManyFailedAttemptsException extends CognitoException {
  TooManyFailedAttemptsException(String message, String details)
      : super(message, details);
}

class TooManyRequestsException extends CognitoException {
  TooManyRequestsException(String message, String details)
      : super(message, details);
}

class UnexpectedLambdaException extends CognitoException {
  UnexpectedLambdaException(String message, String details)
      : super(message, details);
}

class UserLambdaValidationException extends CognitoException {
  UserLambdaValidationException(String message, String details)
      : super(message, details);
}

class UserNotConfirmedException extends CognitoException {
  UserNotConfirmedException(String message, String details)
      : super(message, details);
}

class UserNotFoundException extends CognitoException {
  UserNotFoundException(String message, String details)
      : super(message, details);
}

class UsernameExistsException extends CognitoException {
  UsernameExistsException(String message, String details)
      : super(message, details);
}

class UnknownException extends CognitoException {
  UnknownException(String message, String details) : super(message, details);
}

class NotSignedInException extends CognitoException {
  NotSignedInException(String message, String details)
      : super(message, details);
}

class IdentityIdUnavailableException extends CognitoException {
  IdentityIdUnavailableException(String message, String details)
      : super(message, details);
}

class GuestAccessNotAllowedException extends CognitoException {
  GuestAccessNotAllowedException(String message, String details)
      : super(message, details);
}

class FederationProviderExistsException extends CognitoException {
  FederationProviderExistsException(String message, String details)
      : super(message, details);
}

class CognitoIdentityPoolNotConfiguredException extends CognitoException {
  CognitoIdentityPoolNotConfiguredException(String message, String details)
      : super(message, details);
}

class UnableToSignInException extends CognitoException {
  UnableToSignInException(String message, String details)
      : super(message, details);
}

class InvalidStateException extends CognitoException {
  InvalidStateException(String message, String details)
      : super(message, details);
}

class UserPoolNotConfiguredException extends CognitoException {
  UserPoolNotConfiguredException(String message, String details)
      : super(message, details);
}

class UserCancelledSignInException extends CognitoException {
  UserCancelledSignInException(String message, String details)
      : super(message, details);
}

class BadRequestException extends CognitoException {
  BadRequestException(String message, String details) : super(message, details);
}

class ExpiredRefreshTokenException extends CognitoException {
  ExpiredRefreshTokenException(String message, String details)
      : super(message, details);
}

class ErrorLoadingPageException extends CognitoException {
  ErrorLoadingPageException(String message, String details)
      : super(message, details);
}

class SecurityFailedException extends CognitoException {
  SecurityFailedException(String message, String details)
      : super(message, details);
}

class IdTokenNotIssuedException extends CognitoException {
  IdTokenNotIssuedException(String message, String details)
      : super(message, details);
}

class IdTokenAndAccessTokenNotIssuedException extends CognitoException {
  IdTokenAndAccessTokenNotIssuedException(String message, String details)
      : super(message, details);
}

class InvalidConfigurationException extends CognitoException {
  InvalidConfigurationException(String message, String details)
      : super(message, details);
}

class DeviceNotRememberedException extends CognitoException {
  DeviceNotRememberedException(String message, String details)
      : super(message, details);
}

class AmazonClientException extends CognitoException {
  AmazonClientException(String message, String details)
      : super(message, details);
}

class ApolloException extends CognitoException {
  ApolloException(String message, String details) : super(message, details);
}

class RuntimeException extends CognitoException {
  RuntimeException(String message, String details) : super(message, details);
}

class UnknownHostException extends CognitoException {
  UnknownHostException(String message, String details)
      : super(message, details);
}

class SocketTimeoutException extends CognitoException {
  SocketTimeoutException(String message, String details)
      : super(message, details);
}
