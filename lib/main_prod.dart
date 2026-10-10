import 'enums/app_environment.dart';
import 'main.dart';

/// Production entry point:
/// `flutter run -t lib/main_prod.dart --dart-define-from-file=env/prod.json`.
Future<void> main() => runSooki(AppEnvironment.prod);
