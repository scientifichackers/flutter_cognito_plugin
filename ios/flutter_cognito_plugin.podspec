#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_cognito_plugin'
  s.version          = '0.0.1'
  s.summary          = 'AWS Cognito plugin for flutter '
  s.description      = <<-DESC
AWS Cognito plugin for flutter 
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '9.0'

  s.dependency 'plugin_scaffold'
  s.dependency 'AWSMobileClient', '= 2.9.8'
end
