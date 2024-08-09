import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// The class that contains the information about location with coordinates
@JsonSerializable()
class Location extends Equatable {

  /// Constructor used for json serialization
  const Location({
      this.name,
      this.localNames,
      this.lat,
      this.lon,
      this.country,
      this.state,
    });

  /// Name of the location
  final String? name;

  /// The map of local names, where the key is the language code and the value is the name
  final Map<String, String>? localNames;

  /// Latitude of the location
  final double? lat;

  /// Longitude of the location
  final double? lon;

  /// Country of the location
  final String? country;

  /// State of the location
  final String? state;


  /// Creates a copy of [Location] with specified attributes overridden.
  Location copyWith({
    String? name,
    Map<String, String>? localNames,
    double? lat,
    double? lon,
    String? country,
    String? state,
  }) =>
      Location(
        name: name ?? this.name,
        localNames: localNames ?? this.localNames,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        country: country ?? this.country,
        state: state ?? this.state,
      );


  /// Serialize to json
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  /// Create a new instance from a json
  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  @override
  List<Object?> get props => [
    name,
    localNames,
    lat,
    lon,
    country,
    state,
  ];
}