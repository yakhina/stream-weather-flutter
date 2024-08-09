import 'package:json_annotation/json_annotation.dart';
import 'package:stream_weather/src/core/models/weather_data.dart';
import 'package:stream_weather/src/core/models/location.dart';

part 'responses.g.dart';


class _BaseResponse {
  String? duration;
}

/// Model response for [Response] data
@JsonSerializable()
class ErrorResponse extends _BaseResponse {
  /// The http error code
  int? code;

  /// The message associated to the error code
  String? message;

  /// The backend error code
  int? statusCode;

  /// A detailed message about the error
  String? moreInfo;

  /// Create a new instance from a json
  static ErrorResponse fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => 'ErrorResponse(code: $code, '
      'message: $message, '
      'statusCode: $statusCode, '
      'moreInfo: $moreInfo)';
}

/// Model response for the [timemachine] from One Call API 3.0 of OpenWeather API.
@JsonSerializable(createToJson: false)
class QueryWeatherByDateResponse extends _BaseResponse {
  /// Weather data by date returned by the query
  double? lat;
  double? lon;
  String? timezone;
  @JsonKey(name: 'timezone_offset')
  int? timezoneOffset;

  late List<WeatherData> data;

  /// Create a new instance from a json
  static QueryWeatherByDateResponse fromJson(Map<String, dynamic> json) =>
      _$QueryWeatherByDateResponseFromJson(json);
}

/// Model response for the  [direct] from Geocoding API of OpenWeather API.
@JsonSerializable(createToJson: false)
class QueryCoordinatesByLocationNameResponse extends _BaseResponse {
  /// Location coordinates by location name
  late List<Location>? data;

  /// Create a new instance from a json
  static QueryCoordinatesByLocationNameResponse fromJson(List<dynamic> json) => _$QueryCoordinatesByLocationNameResponseFromJson({"data": json});
}
