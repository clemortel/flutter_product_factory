import 'package:factory_core/factory_core.dart';
import 'package:factory_platform_interface/factory_platform_interface.dart';

/// In-memory fake [ApiClient] for demos and testing.
///
/// Stores data in a [Map] keyed by path. Useful for prototyping
/// without a real backend.
class FakeApiClient implements ApiClient {
  final Map<String, Map<String, dynamic>> _store = {};

  @override
  FutureEither<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    final data = _store[path];
    if (data == null) {
      return const Left(NotFoundFailure('Not found'));
    }
    return Right(data);
  }

  @override
  FutureEither<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    _store[path] = body ?? {};
    return Right(body ?? {});
  }

  @override
  FutureEither<Map<String, dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    _store[path] = body ?? {};
    return Right(body ?? {});
  }

  @override
  FutureEither<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    _store.remove(path);
    return const Right(<String, dynamic>{});
  }
}
