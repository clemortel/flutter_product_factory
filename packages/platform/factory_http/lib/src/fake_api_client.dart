import 'package:factory_core/factory_core.dart';
import 'package:factory_platform_interface/factory_platform_interface.dart';

/// In-memory fake [ApiClient] for demos and testing.
///
/// Stores data in a [Map] keyed by path. Useful for prototyping
/// without a real backend.
class FakeApiClient implements ApiClient {
  final Map<String, Map<String, dynamic>> _store = {};

  @override
  FutureResult<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    final Map<String, dynamic>? data = _store[path];
    if (data == null) {
      return const Err(NotFoundFailure('Not found'));
    }
    return Success(fromJson(data));
  }

  @override
  FutureResult<List<T>> getList<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    final Map<String, dynamic>? data = _store[path];
    if (data == null) {
      return const Err(NotFoundFailure('Not found'));
    }
    final List<dynamic>? items = data['items'] as List<dynamic>?;
    if (items == null) return const Success([]);
    return Success(
      items.cast<Map<String, dynamic>>().map(fromJson).toList(),
    );
  }

  @override
  FutureResult<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final Map<String, dynamic> data = body ?? {};
    _store[path] = data;
    return Success(fromJson(data));
  }

  @override
  FutureResult<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final Map<String, dynamic> data = body ?? {};
    _store[path] = data;
    return Success(fromJson(data));
  }

  @override
  FutureResultVoid delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    _store.remove(path);
    return const Success(null);
  }
}
