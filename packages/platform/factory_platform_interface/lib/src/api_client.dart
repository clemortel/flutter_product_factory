import 'package:factory_core/factory_core.dart';

/// Backend-agnostic HTTP client contract.
///
/// Implement this to connect to your real API, or use [FakeApiClient]
/// for local development and testing.
abstract interface class ApiClient {
  FutureEither<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  FutureEither<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  FutureEither<Map<String, dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  FutureEither<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  });
}
