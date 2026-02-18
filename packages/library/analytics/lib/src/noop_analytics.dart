import 'package:factory_platform_interface/factory_platform_interface.dart';

/// No-op [AnalyticsGateway] that silently discards all events.
///
/// Use as a default in development or when analytics is not configured.
class NoopAnalytics implements AnalyticsGateway {
  const NoopAnalytics();

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}
