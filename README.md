# Dart & Flutter Weather SDKs

## Dart Weather SDK

 * Allows user to fetch weather by exact location coordinates (One Call API 3.0 is used, for more information please fllow the link: https://openweathermap.org/api/one-call-3)
 * Also allows to retrieve locations with cooridnates by a search query (searching by city name, state code or country code). For more documentation about Geocoding API see: https://openweathermap.org/api/one-call-3


## Flutter Weather SDK

Contains `StreamWeather` widget that basically contain 3 widgets to dynamically search for location and show the weather by a chosen one

*  `StreamLocationSearchWidget` a widget that allows to look for location with autocomplete
*  `StreamWeatherWidget` retrieve and show the weather by the given location coordinates
*  `WeatherIconWidget` is a helper widget to show [weather conditions code](https://openweathermap.org/weather-conditions) from as an emoji



