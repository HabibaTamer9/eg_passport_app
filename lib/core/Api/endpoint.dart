import 'package:flutter/foundation.dart';

class Endpoint {
 static const String _localBaseURL = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:5000/',
 );

 static const String _androidEmulatorBaseURL = String.fromEnvironment(
  'ANDROID_API_BASE_URL',
  defaultValue: 'http://192.168.1.18:5000/',
 );

 static String get baseURL {
  final url = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? _androidEmulatorBaseURL
      : _localBaseURL;

  return url.endsWith('/') ? url : '$url/';
 }

 static const String authURL = 'api/auth/';
 static const String appURL = 'api/applications/';
 static const String meProfile = 'api/me/profile';
 static const String my = 'api/me/';

 static const String login = 'login';
 static const String register = 'register';
 static const String personalInfo = 'personal-info';
 static const String forgotPassword = 'forgot-password';
 static const String resetPassword = 'reset-password';
 static const String checkEmail = 'check-email';
 static const String checkPone = 'check-mobile';
 static const String documents = 'documents';
 static const String notifications = 'notifications';
 static const String submit = 'submit';
 static const String status = 'status';
 static const String applications = 'applications';

 static const String sendOTP = 'api/otp/send';
 static const String verifyOTP = 'api/otp/verify';
 static const String resendOTP = 'api/otp/resend';

 static const String uploadDoc = 'api/uploads/document';
 static const String getDoc = 'api/uploads';
 static const String deleteDoc = 'api/uploads';
}
