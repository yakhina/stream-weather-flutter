import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:stream_weather/stream_weather.dart';

///
class StreamWeatherError with EquatableMixin implements Exception {
  ///
  const StreamWeatherError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StreamWeatherError(message: $message)';
}

///
class StreamWeatherNetworkError extends StreamWeatherError {
  ///
  StreamWeatherNetworkError(
    WeatherErrorCode errorCode, {
    int? statusCode,
    this.data,
    this.isRequestCancelledError = false,
  })  : code = errorCode.code,
        statusCode = statusCode ?? data?.statusCode,
        super(errorCode.message);

  ///
  StreamWeatherNetworkError.raw({
    required this.code,
    required String message,
    this.statusCode,
    this.data,
    this.isRequestCancelledError = false,
  }) : super(message);

  ///
  factory StreamWeatherNetworkError.fromDioException(DioException exception) {
    final response = exception.response;
    ErrorResponse? errorResponse;
    final data = response?.data;
    if (data is Map<String, Object?>) {
      errorResponse = ErrorResponse.fromJson(data);
    } else if (data is String) {
      errorResponse = ErrorResponse.fromJson({"data" : data});
    }
    return StreamWeatherNetworkError.raw(
      code: errorResponse?.code ?? -1,
      message: errorResponse?.message ??
          response?.statusMessage ??
          exception.message ??
          '',
      statusCode: errorResponse?.statusCode ?? response?.statusCode,
      data: errorResponse,
      isRequestCancelledError: exception.type == DioExceptionType.cancel,
    )..stackTrace = exception.stackTrace;
  }

  /// Error code
  final int code;

  /// HTTP status code
  final int? statusCode;

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  /// True, in case the error is due to a cancelled network request.
  final bool isRequestCancelledError;

  StackTrace? _stackTrace;

  ///
  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  ///
  WeatherErrorCode? get errorCode => weathertErrorFromCode(code);

  ///
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code, statusCode];

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'StreamWeatherNetworkError($params)';

    if (printStackTrace && _stackTrace != null) {
      msg += '\n$_stackTrace';
    }
    return msg;
  }
}