import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cognito_plugin/exceptions.dart';

final iosErrorRegex = RegExp(
  r'''(AWSMobileClient\.AWSMobileClientError\.)(\w+)(\s*\(\s*message\s*\:\s*['"]\s*)([^\"^\']*)''',
);
final androidErrorRegex = RegExp(
  r'''(com\.amazonaws\.services\.cognitoidentityprovider\.model\.|java\.lang\.|com\.amazonaws\.|java\.net\.)(\w+)''',
);

dynamic convertException(dynamic e) {
  if (e is! PlatformException) return e;

  String code, message, details;
  if (Platform.isAndroid) {
    code = androidErrorRegex.firstMatch(e.code)?.group(2);
    message = e.message;
    details = e.details;
  } else if (Platform.isIOS) {
    final match = iosErrorRegex.firstMatch(e.code);
    code = match?.group(2);
    if (code != null) {
      code = code[0].toUpperCase() + code.substring(1) + "Exception";
    }
    message = match?.group(4);
    details = e.details;
  }

  switch (code) {
    case "SocketTimeoutException":
      return SocketTimeoutException(message, details);
    case "UnknownHostException":
      return UnknownHostException(message, details);
    case "AmazonClientException":
      return AmazonClientException(message, details);
    case "IllegalStateException":
      return InvalidStateException(message, details);
    case "RuntimeException":
      return RuntimeException(message, details);
    case "AliasExistsException":
      return AliasExistsException(message, details);
    case "CodeDeliveryFailureException":
      return CodeDeliveryFailureException(message, details);
    case "CodeMismatchException":
      return CodeMismatchException(message, details);
    case "ExpiredCodeException":
      return ExpiredCodeException(message, details);
    case "GroupExistsException":
      return GroupExistsException(message, details);
    case "InternalErrorException":
      return InternalErrorException(message, details);
    case "InvalidLambdaResponseException":
      return InvalidLambdaResponseException(message, details);
    case "InvalidOAuthFlowException":
      return InvalidOAuthFlowException(message, details);
    case "InvalidParameterException":
      return InvalidParameterException(message, details);
    case "InvalidPasswordException":
      return InvalidPasswordException(message, details);
    case "InvalidUserPoolConfigurationException":
      return InvalidUserPoolConfigurationException(message, details);
    case "LimitExceededException":
      return LimitExceededException(message, details);
    case "MfaMethodNotFoundException":
      return MfaMethodNotFoundException(message, details);
    case "NotAuthorizedException":
      return NotAuthorizedException(message, details);
    case "PasswordResetRequiredException":
      return PasswordResetRequiredException(message, details);
    case "ResourceNotFoundException":
      return ResourceNotFoundException(message, details);
    case "ScopeDoesNotExistException":
      return ScopeDoesNotExistException(message, details);
    case "SoftwareTokenMFANotFoundException":
      return SoftwareTokenMFANotFoundException(message, details);
    case "TooManyFailedAttemptsException":
      return TooManyFailedAttemptsException(message, details);
    case "TooManyRequestsException":
      return TooManyRequestsException(message, details);
    case "UnexpectedLambdaException":
      return UnexpectedLambdaException(message, details);
    case "UserLambdaValidationException":
      return UserLambdaValidationException(message, details);
    case "UserNotConfirmedException":
      return UserNotConfirmedException(message, details);
    case "UserNotFoundException":
      return UserNotFoundException(message, details);
    case "UsernameExistsException":
      return UsernameExistsException(message, details);
    case "UnknownException":
      return UnknownException(message, details);
    case "NotSignedInException":
      return NotSignedInException(message, details);
    case "IdentityIdUnavailableException":
      return IdentityIdUnavailableException(message, details);
    case "GuestAccessNotAllowedException":
      return GuestAccessNotAllowedException(message, details);
    case "FederationProviderExistsException":
      return FederationProviderExistsException(message, details);
    case "CognitoIdentityPoolNotConfiguredException":
      return CognitoIdentityPoolNotConfiguredException(message, details);
    case "UnableToSignInException":
      return UnableToSignInException(message, details);
    case "InvalidStateException":
      return InvalidStateException(message, details);
    case "UserPoolNotConfiguredException":
      return UserPoolNotConfiguredException(message, details);
    case "UserCancelledSignInException":
      return UserCancelledSignInException(message, details);
    case "BadRequestException":
      return BadRequestException(message, details);
    case "ExpiredRefreshTokenException":
      return ExpiredRefreshTokenException(message, details);
    case "ErrorLoadingPageException":
      return ErrorLoadingPageException(message, details);
    case "SecurityFailedException":
      return SecurityFailedException(message, details);
    case "IdTokenNotIssuedException":
      return IdTokenNotIssuedException(message, details);
    case "IdTokenAndAcceessTokenNotIssuedException":
      return IdTokenAndAccessTokenNotIssuedException(message, details);
    case "InvalidConfigurationException":
      return InvalidConfigurationException(message, details);
    case "DeviceNotRememberedException":
      return DeviceNotRememberedException(message, details);
    default:
      return e;
  }
}
