#import "FlutterCognitoPlugin.h"
#import <flutter_cognito_plugin/flutter_cognito_plugin-Swift.h>

@implementation FlutterCognitoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCognitoPlugin registerWithRegistrar:registrar];
}
@end
