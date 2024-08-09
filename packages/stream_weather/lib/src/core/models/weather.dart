import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

/// Units type for the weather data
enum WeatherUnitsType {
  standard,
  metric,
  imperial,
}

/// Getting the correct Units Symbols from the units type
class WeatherUnitsSymbols { 
  /// Getting the correct Degree Symbol ° from the units type
  /// Celsius or Fahrenheit, default is Celsius,
  /// as for the OpenWeather API, the default is Kelvin.
  static String degreeSymbol(WeatherUnitsType type) {
    switch (type) {
      case WeatherUnitsType.imperial:
        return '°F';
      case WeatherUnitsType.metric:
        return '°C';
      case WeatherUnitsType.standard:
        return '°K';
    }
  }
}

/// The class that contains the information about simplified weather data
@JsonSerializable()
class Weather extends Equatable {

  /// Constructor used for json serialization
  Weather({
      int? id,
      this.main,
      this.description,
      this.icon,
    }) : id = id ?? 0;

  /// Id of the weather data item
  final int? id;

  /// The main short description of the weather
  final String? main;

  /// The human-readable description of the weather
  final String? description;

  /// The code of the icon weather
  final String? icon;


  /// Creates a copy of [Weather] with specified attributes overridden.
  Weather copyWith({
    int? id,
    String? main,
    String? description,
    String? icon,
  }) =>
      Weather(
        id: id ?? this.id,
        main: main ?? this.main,
        description: description ?? this.description,
        icon: icon ?? this.icon,
      );


  /// Serialize to json
  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  /// Create a new instance from a json
  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  @override
  List<Object?> get props => [
    id,
    main,
    description,
    icon,
  ];
}