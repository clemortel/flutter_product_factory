import 'package:factory_core/factory_core.dart';

/// Backend-agnostic HTTP client contract.
///
/// Implement this to connect to your real API, or use [FakeApiClient]
/// for local development and testing.
abstract interface class ApiClient {
  /// Performs a GET request and deserializes the response.
  FutureResult<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  /// Performs a GET request and deserializes a list response.
  FutureResult<List<T>> getList<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  /// Performs a POST request and deserializes the response.
  FutureResult<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  /// Performs a PUT request and deserializes the response.
  FutureResult<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });

  /// Performs a DELETE request.
  FutureResultVoid delete(
    String path, {
    Map<String, String>? headers,
  });
}
