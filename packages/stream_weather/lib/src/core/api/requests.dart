import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_weather/stream_weather.dart';

part 'requests.g.dart';

/// Request model for the [timemachine] from One Call API 3.0 of OpenWeather API.
@JsonSerializable(createFactory: false)
class QueryWeatherByDateRequest extends Equatable {

  /// Creates a new QueryWeatherByDateRequest instance.
  const QueryWeatherByDateRequest({
    required this.dt,
    this.lat,
    this.lon,
    this.units,
    required this.appId,
  });

  /// Timestamp of the date to query.
  final int? dt;

  /// Latidude of the location to query.
  final int? lat;

  /// Longitude of the location to query.
  final int? lon;

  /// API key to use for the request.
  @JsonKey(name: 'appid')
  final String appId;

  /// Optional param to specify the units of the weather data.
  final WeatherUnitsType? units;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$QueryWeatherByDateRequestToJson(this);

  @override
  List<Object?> get props => [dt, lat, lon, units, appId];
}


/// Request model for the [direct] from Geocoding API of OpenWeather API.
@JsonSerializable(createFactory: false)
class QueryCoordinatesByLocationNameRequest extends Equatable {

  /// Creates a new QueryCoordinatesByLocationNameRequest instance.
  const QueryCoordinatesByLocationNameRequest({
    this.q,
    required this.appId,
    int? limit,
  }) : limit = limit ?? 5;

  /// City name, state code (only for the US) and country code divided by comma. Please use ISO 3166 country codes.
  final String? q;

  /// API key to use for the request.
  @JsonKey(name: 'appid')
  final String appId;

  final int? limit;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$QueryCoordinatesByLocationNameRequestToJson(this);

  @override
  List<Object?> get props => [q, appId];
}