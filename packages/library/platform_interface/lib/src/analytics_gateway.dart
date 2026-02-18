/// Analytics gateway contract.
///
/// Implement this to integrate with your analytics provider
/// (Firebase Analytics, Mixpanel, Amplitude, etc.).
abstract interface class AnalyticsGateway {
  /// Logs a named event with optional parameters.
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  });

  /// Sets a user property for segmentation.
  Future<void> setUserProperty({
    required String name,
    required String value,
  });

  /// Sets the current user ID for attribution.
  Future<void> setUserId(String? userId);
}
