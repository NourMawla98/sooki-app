/// The backend the app talks to. Each entry point picks one at startup.
enum AppEnvironment {
  /// Local IIS, reached from the Android emulator through its host alias.
  dev(
    baseUrl: 'http://10.0.2.2:1010/api/',
    appSecret: 'dev-secret-change-in-production',
  ),
  prod(
    baseUrl: 'https://sooki-backend.onrender.com/api/',
    appSecret: String.fromEnvironment('SOOKI_APP_SECRET'),
  );

  const AppEnvironment({required this.baseUrl, required this.appSecret});

  final String baseUrl;

  /// Signs guest sign-in requests; must match the backend's APP_SECRET.
  /// The prod value is injected at build time and is empty when the define is missing.
  final String appSecret;
}
