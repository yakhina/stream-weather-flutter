// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:stream_weather/stream_weather.dart';
import 'package:stream_weather_flutter/src/weather/weather_widget.dart';
import 'package:stream_weather_flutter/stream_weather_flutter.dart';

/// {@template streamWeather}
/// Widget used to provide location serach bar and information about the weather
///
/// class MyApp extends StatelessWidget {
///   final StreamWeatherClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamWeather(client: client),
///       ),
///     );
///   }
/// }
///
/// Use [StreamWeather.of] to get the current [StreamWeatherState] instance.
/// {@endtemplate}
class StreamWeather extends StatefulWidget {
  /// {@macro streamWeather}
  const StreamWeather({
    super.key,
    required this.client,
    this.weatherDate,
    this.defaultLocation,
    this.unitsType = WeatherUnitsType.standard,
    this.iconSize = kDefaultEmojiIconSize,
    this.backgroundKeepAlive = const Duration(minutes: 1),
  });


  /// Client to do location operations with
  final StreamWeatherClient client;

  /// DateTime of the weather to display, by default it is the current date
  final DateTime? weatherDate;
  
  /// Param to specify the units of the weather data (standart, metric, imperial)
  final WeatherUnitsType unitsType;

  /// Param to specify emoji icon size
  final double iconSize;

  /// Possible default location to show in the search field
  final Location? defaultLocation;

  /// The amount of time that will pass before disconnecting the client
  /// in the background
  final Duration backgroundKeepAlive;

  @override
  StreamWeatherState createState() => StreamWeatherState();
}

/// The current state of the StreamWeather widget
class StreamWeatherState extends State<StreamWeather> {
  GlobalKey<StreamWeatherWidgetState> weatherWidgetStateKey = GlobalKey();

  /// Gets client from widget
  StreamWeatherClient get client => widget.client;

  /// Curent longitude of the location to display weather info
  double? _longitude;

  /// Curent latitude of the location to display weather info
  double? _latitude;

  @override
  void initState() {
    _longitude = widget.defaultLocation?.lon;
    _latitude = widget.defaultLocation?.lat;
    super.initState();
  }

  /// Refreshes the widget with the current location data
  Future refreshWithLocationData(Location selectedLocation) async {
    setState(() {   
      _longitude = selectedLocation.lon;
      _latitude = selectedLocation.lat;
    });
    await weatherWidgetStateKey.currentState!.queryWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamLocationSearchWidget(client: client, defaultLocation: widget.defaultLocation, onLocationSelectedCallback: (Location selectedLocation) {
          refreshWithLocationData(selectedLocation);
        }),
        StreamWeatherWidget(key: weatherWidgetStateKey, client: client, latitude: _latitude, longitude: _longitude, unitsType: widget.unitsType, iconSize: widget.iconSize),
      ],
    );
  }
}