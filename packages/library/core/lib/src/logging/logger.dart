/// Contract for logging throughout the application.
///
/// Implement this to integrate with your preferred logging backend
/// (e.g., Firebase Crashlytics, Sentry, DataDog).
abstract interface class AppLogger {
  void debug(String message, {Object? error, StackTrace? stackTrace});
  void info(String message, {Object? error, StackTrace? stackTrace});
  void warning(String message, {Object? error, StackTrace? stackTrace});
  void error(String message, {Object? error, StackTrace? stackTrace});
}
