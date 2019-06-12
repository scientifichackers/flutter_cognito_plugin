import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cognito_plugin/exceptions.dart';

final iosErrorRegex = RegExp(
  r'''(AWSMobileClient\.AWSMobileClientError\.)(\w+)(\s*\(\s*message\s*\:\s*['"]\s*)([^\"^\']*)''',
);
final androidErrorRegex = RegExp(
  r'''(com\.amazonaws\.services\.cognitoidentityprovider\.model\.|java\.lang\.|com\.amazonaws\.|java\.net\.)(\w+)''',
);

void rethrowException(e) {
  if (e is! PlatformException) throw e;

  String code, message, details;
  if (Platform.isAndroid) {
    code = androidErrorRegex.firstMatch(e.code)?.group(2);
    message = e.message;
    details = e.details;
  } else if (Platform.isIOS) {
    final match = iosErrorRegex.firstMatch(e.code);
    code = match?.group(2);
    code = code[0].toUpperCase() + code.substring(1) + "Exception";
    message = match?.group(4);
    details = e.details;
  }

  switch (code) {
    case "UnknownHostException":
      throw UnknownHostException(message, details);
    case "AmazonClientException":
      throw AmazonClientException(message, details);
    case "IllegalStateException":
      throw InvalidStateException(message, details);
    case "RuntimeException":
      throw RuntimeException(message, details);
    case "AliasExistsException":
      throw AliasExistsException(message, details);
    case "CodeDeliveryFailureException":
      throw CodeDeliveryFailureException(message, details);
    case "CodeMismatchException":
      throw CodeMismatchException(message, details);
    case "ExpiredCodeException":
      throw ExpiredCodeException(message, details);
    case "GroupExistsException":
      throw GroupExistsException(message, details);
    case "InternalErrorException":
      throw InternalErrorException(message, details);
    case "InvalidLambdaResponseException":
      throw InvalidLambdaResponseException(message, details);
    case "InvalidOAuthFlowException":
      throw InvalidOAuthFlowException(message, details);
    case "InvalidParameterException":
      throw InvalidParameterException(message, details);
    case "InvalidPasswordException":
      throw InvalidPasswordException(message, details);
    case "InvalidUserPoolConfigurationException":
      throw InvalidUserPoolConfigurationException(message, details);
    case "LimitExceededException":
      throw LimitExceededException(message, details);
    case "MfaMethodNotFoundException":
      throw MfaMethodNotFoundException(message, details);
    case "NotAuthorizedException":
      throw NotAuthorizedException(message, details);
    case "PasswordResetRequiredException":
      throw PasswordResetRequiredException(message, details);
    case "ResourceNotFoundException":
      throw ResourceNotFoundException(message, details);
    case "ScopeDoesNotExistException":
      throw ScopeDoesNotExistException(message, details);
    case "SoftwareTokenMFANotFoundException":
      throw SoftwareTokenMFANotFoundException(message, details);
    case "TooManyFailedAttemptsException":
      throw TooManyFailedAttemptsException(message, details);
    case "TooManyRequestsException":
      throw TooManyRequestsException(message, details);
    case "UnexpectedLambdaException":
      throw UnexpectedLambdaException(message, details);
    case "UserLambdaValidationException":
      throw UserLambdaValidationException(message, details);
    case "UserNotConfirmedException":
      throw UserNotConfirmedException(message, details);
    case "UserNotFoundException":
      throw UserNotFoundException(message, details);
    case "UsernameExistsException":
      throw UsernameExistsException(message, details);
    case "UnknownException":
      throw UnknownException(message, details);
    case "NotSignedInException":
      throw NotSignedInException(message, details);
    case "IdentityIdUnavailableException":
      throw IdentityIdUnavailableException(message, details);
    case "GuestAccessNotAllowedException":
      throw GuestAccessNotAllowedException(message, details);
    case "FederationProviderExistsException":
      throw FederationProviderExistsException(message, details);
    case "CognitoIdentityPoolNotConfiguredException":
      throw CognitoIdentityPoolNotConfiguredException(message, details);
    case "UnableToSignInException":
      throw UnableToSignInException(message, details);
    case "InvalidStateException":
      throw InvalidStateException(message, details);
    case "UserPoolNotConfiguredException":
      throw UserPoolNotConfiguredException(message, details);
    case "UserCancelledSignInException":
      throw UserCancelledSignInException(message, details);
    case "BadRequestException":
      throw BadRequestException(message, details);
    case "ExpiredRefreshTokenException":
      throw ExpiredRefreshTokenException(message, details);
    case "ErrorLoadingPageException":
      throw ErrorLoadingPageException(message, details);
    case "SecurityFailedException":
      throw SecurityFailedException(message, details);
    case "IdTokenNotIssuedException":
      throw IdTokenNotIssuedException(message, details);
    case "IdTokenAndAcceessTokenNotIssuedException":
      throw IdTokenAndAccessTokenNotIssuedException(message, details);
    case "InvalidConfigurationException":
      throw InvalidConfigurationException(message, details);
    case "DeviceNotRememberedException":
      throw DeviceNotRememberedException(message, details);
    default:
      throw e;
  }
}
