import 'package:dio/dio.dart';

import '../../logging/app_logger.dart';

/// Logs requests/responses in debug builds.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      '<-- ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.w(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.method} '
      '${err.requestOptions.uri}',
      error: err,
    );
    handler.next(err);
  }
}
