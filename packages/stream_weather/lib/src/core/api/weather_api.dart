import 'package:stream_weather/src/core/http/stream_weather_http_client.dart';
import 'package:stream_weather/stream_weather.dart';

/// Defines the api dedicated to users operations
class WeatherApi {
  /// Initialize a new weather api
  WeatherApi(this._client);

  final StreamWeatherHttpClient _client;

  /// Requests weather with a given date or for now by default.
  Future<QueryWeatherByDateResponse> queryWeather({
    double? lat,
    double? lon,
    int? dt,
    WeatherUnitsType? units,
    String? appId,
  }) async {
    final response = await _client.get(
      '/data/3.0/onecall/timemachine',
      queryParameters: {
          'lat': lat,
          'lon': lon,
          'units': units?.name ?? WeatherUnitsType.standard.name,
          if (dt != null) 'dt': timestampInMillisecondsToSeconds(DateTime.now().millisecondsSinceEpoch),
          if (appId != null) 'appid': appId,
      },
    );
    return QueryWeatherByDateResponse.fromJson(response.data);
  }

}