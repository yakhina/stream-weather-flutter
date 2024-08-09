import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_weather/src/core/models/weather.dart';
import 'package:stream_weather/stream_weather.dart';

part 'weather_data.g.dart';


/// The class that contains the information about main weather data
@JsonSerializable()
class WeatherData extends Equatable {
  /// Constructor used for json serialization
  WeatherData({
      int? dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.weather,
    }) : dt = dt ?? timestampInMillisecondsToSeconds(DateTime.now().millisecondsSinceEpoch);

  /// The timestamp of the requested date
  final int? dt;

  /// The timestamp of the sunrise
  final int? sunrise;

  /// The timestamp of the sunset
  final int? sunset;

  /// The main tempurature value for the current date. Units – default: kelvin, metric: Celsius, imperial: Fahrenheit.
  final double? temp;

  /// The tempurature of how it feels like
  @JsonKey(name: 'feels_like')
  final double? feelsLike;

  /// The atmospheric pressure value
  final int? pressure;

  /// The humidity value
  final int? humidity;

  /// The dew point value
  @JsonKey(name: 'dew_point')
  final double? dewPoint;

  /// The UV Index value
  final double? uvi;

  /// The Clouds value
  final int? clouds;

  /// The Visibility value
  final int? visibility;

  /// The wind speed value 
  @JsonKey(name: 'wind_speed')
  final double? windSpeed;

  /// The wind direction angle value
  @JsonKey(name: 'wind_deg')
  final int? windDeg;

  /// The weather data simplify item
  final List<Weather?>? weather;


  /// Creates a copy of [WeatherData] with specified attributes overridden.
  WeatherData copyWith({
    int? dt,
    int? sunrise,
    int? sunset,
    double? temp,
    double? feelsLike,
    int? pressure,
    int? humidity,
    double? dewPoint,
    double? uvi,
    int? clouds,
    int? visibility,
    double? windSpeed,
    int? windDeg,
    List<Weather?>? weather,
  }) =>
      WeatherData(
        dt: dt ?? this.dt,
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
        temp: temp ?? this.temp,
        feelsLike: feelsLike ?? this.feelsLike,
        pressure: pressure ?? this.pressure,
        humidity: humidity ?? this.humidity,
        dewPoint: dewPoint ?? this.dewPoint,
        uvi: uvi ?? this.uvi,
        clouds: clouds ?? this.clouds,
        visibility: visibility ?? this.visibility,
        windSpeed: windSpeed ?? this.windSpeed,
        windDeg: windDeg ?? this.windDeg,
        weather: weather ?? this.weather,
      );


  /// Serialize to json
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);


  /// Create a new instance from a json
  factory WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

  @override
  List<Object?> get props => [
    dt,
    sunrise,
    sunset,
    temp,
    feelsLike,
    pressure,
    humidity,
    dewPoint,
    uvi,
    clouds,
    visibility,
    windSpeed,
    windDeg,
    weather,
  ];
}