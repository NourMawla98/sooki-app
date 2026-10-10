import '../enums/app_environment.dart';

class AppConfig {
  /// Set once by the entry point before anything reads [baseUrl] or [appSecret].
  static AppEnvironment environment = AppEnvironment.dev;

  static String get baseUrl => environment.baseUrl;
  static String get appSecret => environment.appSecret;
}
