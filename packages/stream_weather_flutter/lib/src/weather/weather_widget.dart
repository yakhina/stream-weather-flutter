// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_weather/stream_weather.dart';
import 'package:stream_weather_flutter/src/weather/weather_icon_emoji.dart';

/// Default debounce duration in milliseconds
const int kDefaultDebounceDurationMilliseconds = 300;

/// Default icon size for the weather icon
const double kDefaultEmojiIconSize = 100;

/// Widget used to provide search field and autocomplete behaviour for locations
class StreamWeatherWidget extends StatefulWidget {
  /// Constructor for the [StreamWeatherWidget] widget
  const StreamWeatherWidget(
      {super.key,
      required this.client,
      this.weatherDate,
      this.longitude,
      this.latitude,
      this.unitsType = WeatherUnitsType.standard,
      this.iconSize = kDefaultEmojiIconSize});

  /// Client to do location operations with
  final StreamWeatherClient client;

  /// DateTime of the weather to display, by default it is the current date
  final DateTime? weatherDate;
  
  /// Param to specify the units of the weather data (standart, metric, imperial)
  final WeatherUnitsType unitsType;

  /// Param to specify emoji icon size
  final double iconSize;

  /// Longitude of the location to display weather info 
  final double? longitude;

  /// Latitude of the location to display weather info 
  final double? latitude;

  @override
  StreamWeatherWidgetState createState() =>
      StreamWeatherWidgetState();
}

class StreamWeatherWidgetState
    extends State<StreamWeatherWidget> {
  WeatherData? _currentWeatherData;

  Future<WeatherData?> _queryWeather() async {
    if (widget.longitude == null || widget.latitude == null) {
      return null;
    }
    // Setup the default date for the request
    // To show initial weather data unless users changes the date
    final dateTimestamp = widget.weatherDate != null ? widget.weatherDate!.millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;

    final weatherData = widget.client
        .queryWeather(lon: widget.longitude, lat: widget.latitude, dt: timestampInMillisecondsToSeconds(dateTimestamp), units: widget.unitsType)
        .then((response) {
      return response.data.first;
    });

    return weatherData;
  }

  @override
  void initState() {
    super.initState();
    queryWeather();
  }

  /// Refreshes the widget with the current location data
  Future queryWeather() async {
    setState(() {
      _currentWeatherData = null;
    });
    await _queryWeather().then((weatherData) {
      setState(() {
        _currentWeatherData = weatherData;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return _currentWeatherData != null && widget.latitude != null && widget.longitude != null ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_currentWeatherData?.temp ?? "-.-"} ${WeatherUnitsSymbols.degreeSymbol(widget.unitsType)}', 
                style: Theme.of(context).textTheme.titleLarge
              ),
              Text(_currentWeatherData?.weather?.first?.main ?? '', 
                style: Theme.of(context).textTheme.titleMedium),
              Text(_currentWeatherData?.weather?.first?.description ?? ''),
          ],
        ),
        WeatherIconWidget(iconCodeName : _currentWeatherData?.weather?.first?.icon ?? '', size: widget.iconSize),
      ],
    ) : const Center(child: CircularProgressIndicator(strokeWidth: 10));
  }
}