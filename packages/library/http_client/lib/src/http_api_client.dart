import 'dart:convert';

import 'package:core/core.dart';
import 'package:platform_interface/platform_interface.dart';
import 'package:http/http.dart' as http;

/// HTTP implementation of [ApiClient] using `package:http`.
class HttpApiClient implements ApiClient {
  HttpApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.defaultHeaders = const {},
  }) : _client = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final Map<String, String> defaultHeaders;

  Map<String, String> _mergeHeaders(Map<String, String>? headers) => {
        'Content-Type': 'application/json',
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);

  Either<Failure, Map<String, dynamic>> _decodeResponse(
    http.Response response,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return const Right(<String, dynamic>{});
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return Right(decoded);
      return Right(<String, dynamic>{'data': decoded});
    }
    if (response.statusCode == 401) {
      return const Left(UnauthorizedFailure('Unauthorized'));
    }
    if (response.statusCode == 404) {
      return const Left(NotFoundFailure('Resource not found'));
    }
    return Left(
      ServerFailure(
        'Server error: ${response.statusCode}',
        statusCode: response.statusCode,
      ),
    );
  }

  @override
  FutureResult<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final http.Response response = await _client.get(
        _buildUri(path, queryParameters: queryParameters),
        headers: _mergeHeaders(headers),
      );
      final Either<Failure, Map<String, dynamic>> raw =
          _decodeResponse(response);
      return raw.match(
        (failure) => Left(failure),
        (value) => Right(fromJson(value)),
      );
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureResult<List<T>> getList<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final http.Response response = await _client.get(
        _buildUri(path, queryParameters: queryParameters),
        headers: _mergeHeaders(headers),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is List) {
          return Right(
            decoded
                .cast<Map<String, dynamic>>()
                .map(fromJson)
                .toList(),
          );
        }
        return const Left(
          ServerFailure('Expected a JSON array response'),
        );
      }
      final Either<Failure, Map<String, dynamic>> raw =
          _decodeResponse(response);
      return raw.match(
        (failure) => Left(failure),
        (_) => const Left(ServerFailure('Expected a JSON array response')),
      );
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureResult<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final http.Response response = await _client.post(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      final Either<Failure, Map<String, dynamic>> raw =
          _decodeResponse(response);
      return raw.match(
        (failure) => Left(failure),
        (value) => Right(fromJson(value)),
      );
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureResult<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final http.Response response = await _client.put(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      final Either<Failure, Map<String, dynamic>> raw =
          _decodeResponse(response);
      return raw.match(
        (failure) => Left(failure),
        (value) => Right(fromJson(value)),
      );
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureResultVoid delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final http.Response response = await _client.delete(
        _buildUri(path),
        headers: _mergeHeaders(headers),
      );
      final Either<Failure, Map<String, dynamic>> raw =
          _decodeResponse(response);
      return raw.match(
        (failure) => Left(failure),
        (_) => const Right(unit),
      );
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
