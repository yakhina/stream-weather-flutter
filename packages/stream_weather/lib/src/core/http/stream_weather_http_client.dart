import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_weather/src/core/error/error.dart';
import 'package:stream_weather/src/core/http/stream_weather_dio_error.dart';
import 'package:stream_weather/src/core/http/stream_weather_logging_interceptor.dart';

part 'stream_weather_http_client_options.dart';

class StreamWeatherHttpClient {
  /// [StreamWeatherHttpClient] constructor
  StreamWeatherHttpClient(
    this.appId, {
    Dio? dio,
    StreamWeatherHttpClientOptions? options,
    Logger? logger,
    Iterable<Interceptor>? interceptors,
  })  : _options = options ?? const StreamWeatherHttpClientOptions(),
        httpClient = dio ?? Dio() {
    httpClient
      ..options.baseUrl = _options.baseUrl
      ..options.receiveTimeout = _options.receiveTimeout
      ..options.connectTimeout = _options.connectTimeout
      ..options.queryParameters = {
        'appid': appId,
        ..._options.queryParameters,
      }
      ..options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ..._options.headers,
      }
      ..interceptors.addAll(
            [
              // Add a default logging interceptor if no interceptors are
              // provided.
              if (logger != null && logger.level != Level.OFF)
                LoggingInterceptor(
                  requestHeader: true,
                  logPrint: (step, message) {
                    switch (step) {
                      case InterceptStep.request:
                        return logger.info(message);
                      case InterceptStep.response:
                        return logger.info(message);
                      case InterceptStep.error:
                        return logger.severe(message);
                    }
                  },
                ),
            ]);
  }

  /// The user Openweather API key.
  String? appId;

  /// Your project Stream Weather ClientOptions
  final StreamWeatherHttpClientOptions _options;

  /// [Dio] httpClient
  /// It's been chosen because it's easy to use
  /// and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  final Dio httpClient;

  /// Shuts down the [StreamWeatherHttpClient].
  ///
  /// If [force] is `false` the [StreamWeatherHttpClient] will be kept alive
  /// until all active connections are done. If [force] is `true` any active
  /// connections will be closed to immediately release all resources. These
  /// closed connections will receive an error event to indicate that the client
  /// was shut down. In both cases trying to establish a new connection after
  /// calling [close] will throw an exception.
  void close({bool force = false}) => httpClient.close(force: force);

  StreamWeatherNetworkError _parseError(DioException exception) {
    StreamWeatherNetworkError error;
    // locally thrown dio error
    if (exception is StreamWeatherDioError) {
      error = exception.error;
    } else {
      // real network request dio error
      error = StreamWeatherNetworkError.fromDioException(exception);
    }
    return error..stackTrace = exception.stackTrace;
  }

  /// Handy method to make http GET request with error parsing.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.post<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.delete<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.patch<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.put<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to post files with error parsing.
  Future<Response<T>> postFile<T>(
    String path,
    MultipartFile file, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({'file': file});
    final response = await post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      headers: headers,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// Handy method to make generic http request with error parsing.
  Future<Response<T>> request<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http requests from [RequestOptions]
  /// with error parsing.
  Future<Response<T>> fetch<T>(
    RequestOptions requestOptions,
  ) async {
    try {
      final response = await httpClient.fetch<T>(requestOptions);
      return response;
    } on DioException catch (error) {
      throw _parseError(error);
    }
  }
}