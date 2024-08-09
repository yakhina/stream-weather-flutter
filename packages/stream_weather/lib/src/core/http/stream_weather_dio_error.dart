import 'package:dio/dio.dart';
import 'package:stream_weather/src/core/error/error.dart';

/// Error class specific to StreamWeather and Dio
class StreamWeatherDioError extends DioException {
  /// Initialize a stream weather dio error
  StreamWeatherDioError({
    required this.error,
    required super.requestOptions,
    super.response,
    super.type,
  }) : super(
          error: error,
        );

  @override
  final StreamWeatherNetworkError error;
}