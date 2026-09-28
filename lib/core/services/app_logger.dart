import 'dart:developer' as developer;

abstract final class AppLogger {
  static void info(String message) {
    developer.log(message, name: 'DebtPilot');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'DebtPilot',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  static void warning(String message) {
    developer.log(message, name: 'DebtPilot', level: 900);
  }
}
