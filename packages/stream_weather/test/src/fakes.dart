import 'package:mocktail/mocktail.dart';
import 'package:stream_weather/src/core/api/stream_weather_api.dart';
import 'package:stream_weather/stream_weather.dart';

import 'mocks.dart';

class FakeStreamWeatherApi extends Fake implements StreamWeatherApi {
  WeatherApi? _weather;

  @override
  WeatherApi get weather => _weather ??= MockWeatherApi();

  LocationsApi? _locations;

  @override
  LocationsApi get locations => _locations ??= MockLocationsApi();

}
