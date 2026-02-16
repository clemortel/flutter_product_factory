import 'dart:convert';

import 'package:factory_core/factory_core.dart';
import 'package:factory_platform_interface/factory_platform_interface.dart';
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

  Either<Failure, Map<String, dynamic>> _handleResponse(
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
  FutureEither<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final response = await _client.get(
        _buildUri(path, queryParameters: queryParameters),
        headers: _mergeHeaders(headers),
      );
      return _handleResponse(response);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.post(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client.put(
        _buildUri(path),
        headers: _mergeHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.delete(
        _buildUri(path),
        headers: _mergeHeaders(headers),
      );
      return _handleResponse(response);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
