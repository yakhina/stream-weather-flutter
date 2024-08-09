import 'package:stream_weather/src/core/api/responses.dart';
import 'package:stream_weather/src/core/http/stream_weather_http_client.dart';

//http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}

/// Defines the api dedicated to locations operations
/// Possibly could be extended to support full list 
/// of methods of Openweathermap Geocoding API: https://openweathermap.org/api/geocoding-api
class LocationsApi {
  /// Initialize a new locations api
  LocationsApi(this._client);

  final StreamWeatherHttpClient _client;

  /// Requests coordinates by location name
  Future<QueryCoordinatesByLocationNameResponse> queryCoordinates({
    String? q,
    int? limit,
    String? appId,
  }) async {
    final response = await _client.get(
      '/geo/1.0/direct',
      queryParameters: {
          'q': q,
          if (limit != null) 'limit': 5,
          if (appId != null) 'appid': appId,
        },
    );
    return QueryCoordinatesByLocationNameResponse.fromJson(response.data);
  }

}