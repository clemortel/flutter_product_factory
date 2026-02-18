import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:platform_interface/platform_interface.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// HTTP implementation of [ApiClient] using [Dio].
class HttpApiClient implements ApiClient {
  HttpApiClient({
    required String baseUrl,
    Dio? dio,
    Talker? talker,
    Map<String, String> defaultHeaders = const {},
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  ...defaultHeaders,
                },
              ),
            ) {
    if (talker != null) {
      _dio.interceptors.add(TalkerDioLogger(talker: talker));
    }
  }

  final Dio _dio;

  Either<Failure, Map<String, dynamic>> _decodeResponse(Response<dynamic> response) {
    final dynamic data = response.data;
    if (data is Map<String, dynamic>) return Right(data);
    if (data == null) return const Right(<String, dynamic>{});
    return Right(<String, dynamic>{'data': data});
  }

  Failure _mapDioException(DioException e) {
    final int? statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      return const UnauthorizedFailure('Unauthorized');
    }
    if (statusCode == 404) {
      return const NotFoundFailure('Resource not found');
    }
    if (statusCode != null && statusCode >= 400) {
      return ServerFailure(
        'Server error: $statusCode',
        statusCode: statusCode,
      );
    }
    return NetworkFailure(e.message ?? e.toString());
  }

  @override
  FutureResult<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        options: headers != null ? Options(headers: headers) : null,
        queryParameters: queryParameters,
      );
      final Either<Failure, Map<String, dynamic>> raw = _decodeResponse(response);
      return raw.match(
        (Failure failure) => Left(failure),
        (Map<String, dynamic> value) => Right(fromJson(value)),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
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
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        options: headers != null ? Options(headers: headers) : null,
        queryParameters: queryParameters,
      );
      final dynamic data = response.data;
      if (data is List) {
        return Right(
          data.cast<Map<String, dynamic>>().map(fromJson).toList(),
        );
      }
      return const Left(
        ServerFailure('Expected a JSON array response'),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
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
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );
      final Either<Failure, Map<String, dynamic>> raw = _decodeResponse(response);
      return raw.match(
        (Failure failure) => Left(failure),
        (Map<String, dynamic> value) => Right(fromJson(value)),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
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
      final Response<dynamic> response = await _dio.put<dynamic>(
        path,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
      );
      final Either<Failure, Map<String, dynamic>> raw = _decodeResponse(response);
      return raw.match(
        (Failure failure) => Left(failure),
        (Map<String, dynamic> value) => Right(fromJson(value)),
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    }
  }

  @override
  FutureResultVoid delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    try {
      await _dio.delete<dynamic>(
        path,
        options: headers != null ? Options(headers: headers) : null,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    }
  }
}
