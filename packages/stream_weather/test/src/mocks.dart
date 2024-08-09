import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

import 'package:stream_weather/src/client/client.dart';
import 'package:stream_weather/src/core/api/weather_api.dart';
import 'package:stream_weather/src/core/api/locations_api.dart';
import 'package:stream_weather/src/core/http/stream_weather_http_client.dart';


class MockDio extends Mock implements Dio {
  BaseOptions? _options;

  @override
  BaseOptions get options => _options ??= BaseOptions();

  Interceptors? _interceptors;

  @override
  Interceptors get interceptors => _interceptors ??= Interceptors();
}

class MockLogger extends Mock implements Logger {
  @override
  Level get level => Level.ALL;
}

class MockHttpClient extends Mock implements StreamWeatherHttpClient {}

class MockWeatherApi extends Mock implements WeatherApi {}

class MockLocationsApi extends Mock implements LocationsApi {}

class MockStreamWeatherClient extends Mock implements StreamWeatherClient {
}
