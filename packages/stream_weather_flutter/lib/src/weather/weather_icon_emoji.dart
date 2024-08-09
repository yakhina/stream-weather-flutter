import 'package:flutter/material.dart';

/// Emoji symbols icons map or weather type from the icon code, 
/// retreived from the OpenWeatherMap API
/// https://openweathermap.org/weather-conditions
final Map<String, String> emojiIconsSymbols = {
  '01d' : '☀️',
  '02d' : '🌤️',
  '03d' : '🌥️',
  '04d' : '☁️',
  '09d' : '🌧️',
  '10d' : '🌦️',
  '11d' : '⛈☀️',
  '13d' : '❄️☀️',
  '50d' : '🌫️☀️',
  '01n' : '🌑',
  '02n' : '☁🌑',
  '03n' : '☁️🌑',
  '04n' : '️️☁️☁️🌑',
  '09n' : '🌧️🌑',
  '10n' : '🌧️🌑',
  '11n' : '🌩️🌑',
  '13n' : '❄️🌑',
  '50n' : '🌫️🌑',
  'unknown' : '🌡️'
};

/// Getting emoji symbols icon or weather type from the icon code, 
/// retreived from the OpenWeatherMap API
class WeatherTypeIcon { 
  /// Getting emoji symbols icon or weather type from the icon code,
  /// Otherwise, return the unknown icon
  static String emojiStringIcon(String iconCodeName) {
    return emojiIconsSymbols[iconCodeName] ?? emojiIconsSymbols.entries.last.value;
  }
}

/// the widget to show emoji icon with predeined size as an icon
class WeatherIconWidget extends StatelessWidget {

  /// Constructor for the [WeatherIconWidget] widget
  const WeatherIconWidget({super.key, required  this.iconCodeName, required  this.size});

  /// Icon code name
  final String iconCodeName;

  /// Icon size
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Text(
        WeatherTypeIcon.emojiStringIcon(iconCodeName),
        style: TextStyle(fontSize: size * 0.8),
      ),
    );
  }
}
