import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:stream_weather/src/core/api/weather_api.dart';
import 'package:stream_weather/src/core/api/locations_api.dart';
import 'package:stream_weather/src/core/http/stream_weather_http_client.dart';

/// ApiClient that wraps every other specific api
class StreamWeatherApi {
  /// Initialize a new stream chat api
  StreamWeatherApi(
    String apiKey, {
    StreamWeatherHttpClient? client,
    StreamWeatherHttpClientOptions? options,
    Logger? logger,
    Iterable<Interceptor>? interceptors,
  })  :  _client = client ??
            StreamWeatherHttpClient(
              apiKey,
              options: options,
              logger: logger,
              interceptors: interceptors,
            );

  final StreamWeatherHttpClient _client;

  WeatherApi? _weather;

  /// Api dedicated to wearther operations
  WeatherApi get weather => _weather ??= WeatherApi(_client);


  LocationsApi? _locations;

  /// Api dedicated to locations operations
  LocationsApi get locations => _locations ??= LocationsApi(_client);
}