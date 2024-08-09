// // ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stream_weather/stream_weather.dart';
import 'package:stream_weather_flutter/stream_weather_flutter.dart';


/// Default location's coordinates (Stream office's longitude in Amsterdam)
/// TODO: expand default data to be the user's current location
/// if the user allows it
const Location defaultLocation = Location(lat: 44.6114149, lon: -1.224436, name: 'Amsterdam', country: 'NL', state: 'NH', localNames: {'en': 'Amsterdam', 'nl': 'Amsterdam'});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamWeatherClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamWeatherClient(
    'a706c736c3a9c2f709bd464599250842',
    logLevel: Level.ALL,
  );


  runApp(
    MyApp(
      client: client,
    ),
  );
}

/// Example application using Stream Weather Flutter widgets.
///
/// Stream Weather Flutter is a set of Flutter widgets which provide full weather
/// functionalities for building Flutter applications using Stream. If you'd
/// prefer using minimal wrapper widgets for your app, please see our other
/// package, `stream_weather_flutter_core`.
class MyApp extends StatelessWidget {

  /// Creates a new instance of MyApp.
  const MyApp({
    super.key,
    required this.client,
  });

  /// Instance of Stream Weather Client.
  ///
  /// Stream's [StreamWeatherClient] can be used to connect to Openweather API 
  /// servers and provide API to fetch weather data. It can also
  /// retrieve location data from Openweather Geocode API.
  final StreamWeatherClient client;


  @override
  Widget build(BuildContext context) {
    final textStyleWithShadow = TextStyle(color: Colors.black87, shadows: [
      BoxShadow(
        color: Colors.black87.withOpacity(0.25),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 0.5),
      )
    ]);

    return MaterialApp(
      title: 'Flutter App Example to show Weather Widgets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: textStyleWithShadow,
          displayMedium: textStyleWithShadow,
          displaySmall: textStyleWithShadow,
          headlineMedium: textStyleWithShadow,
          headlineSmall: textStyleWithShadow,
          titleMedium: const TextStyle(color: Colors.black87),
          bodyMedium: const TextStyle(color: Colors.black87),
          bodyLarge: const TextStyle(color: Colors.black87),
          bodySmall: const TextStyle(color: Colors.black87, fontSize: 13),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: StreamWeather(client: client, unitsType: WeatherUnitsType.metric, defaultLocation: defaultLocation),
          ),
        ),
      ),
    );
  }
}