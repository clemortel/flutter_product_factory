import 'package:core/core.dart';
import 'package:platform_interface/platform_interface.dart';

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
      return const Left(NotFoundFailure('Not found'));
    }
    return Right(fromJson(data));
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
      return const Left(NotFoundFailure('Not found'));
    }
    final List<dynamic>? items = data['items'] as List<dynamic>?;
    if (items == null) return const Right([]);
    return Right(
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
    return Right(fromJson(data));
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
    return Right(fromJson(data));
  }

  @override
  FutureResultVoid delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    _store.remove(path);
    return const Right(unit);
  }
}
