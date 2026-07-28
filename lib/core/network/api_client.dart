import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_env.dart';
import '../errors/app_exception.dart';
import '../errors/result.dart';
import '../logging/app_logger.dart';
import '../storage/secure_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Thin, typed wrapper around [Dio].
///
/// All methods return a [Result] — callers never need try/catch:
/// ```dart
/// final result = await ref.read(apiClientProvider).get<Map<String, dynamic>>('/me');
/// ```
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? decode,
  }) =>
      _run<T>(() => _dio.get<dynamic>(path, queryParameters: queryParameters),
          decode);

  Future<Result<T>> post<T>(
    String path, {
    Object? data,
    T Function(dynamic data)? decode,
  }) =>
      _run<T>(() => _dio.post<dynamic>(path, data: data), decode);

  Future<Result<T>> put<T>(
    String path, {
    Object? data,
    T Function(dynamic data)? decode,
  }) =>
      _run<T>(() => _dio.put<dynamic>(path, data: data), decode);

  Future<Result<T>> delete<T>(
    String path, {
    Object? data,
    T Function(dynamic data)? decode,
  }) =>
      _run<T>(() => _dio.delete<dynamic>(path, data: data), decode);

  Future<Result<T>> _run<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data)? decode,
  ) async {
    try {
      final response = await request();
      final data = response.data;
      if (decode != null) return Success(decode(data));
      return Success(data as T);
    } on DioException catch (e, st) {
      return Failure(_mapDioError(e, st));
    } on Object catch (e, st) {
      AppLogger.e('Unexpected error in ApiClient', error: e, stackTrace: st);
      return Failure(
        e is TypeError
            ? ParsingException('Unexpected response shape', cause: e, stackTrace: st)
            : UnknownException('Unexpected error', cause: e, stackTrace: st),
      );
    }
  }

  AppException _mapDioError(DioException e, StackTrace st) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Request timed out', cause: e, stackTrace: st);
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection', cause: e, stackTrace: st);
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401 || status == 403) {
          return UnauthorizedException('Not authorized', cause: e, stackTrace: st);
        }
        return ServerException(
          'Server error ($status)',
          statusCode: status,
          cause: e,
          stackTrace: st,
        );
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');
      case DioExceptionType.badCertificate:
        return NetworkException('Bad certificate', cause: e, stackTrace: st);
      case DioExceptionType.unknown:
        return UnknownException('Network error', cause: e, stackTrace: st);
      // ignore: unreachable_switch_case — future-proof against new enum values
      default:
        return UnknownException('Network error', cause: e, stackTrace: st);
    }
  }
}

/// Configured [Dio] instance with base URL, timeouts and interceptors.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );
  dio.interceptors.add(AuthInterceptor(ref.read(secureStorageProvider)));
  if (AppEnv.enableNetworkLogs) {
    dio.interceptors.add(LoggingInterceptor());
  }
  return dio;
});

/// The app-wide API client.
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);
