# Dart & Flutter Weather SDKs

## Dart Weather SDK

 * Allows user to fetch weather by exact location coordinates (One Call API 3.0 is used, for more information please fllow the link: https://openweathermap.org/api/one-call-3)
 * Also allows to retrieve locations with cooridnates by a search query (searching by city name, state code or country code). For more documentation about Geocoding API see: https://openweathermap.org/api/one-call-3


## Flutter Weather SDK

### Contains `StreamWeather` widget that basically contain 3 widgets to dynamically search for location and show the weather by a chosen one

*  `StreamLocationSearchWidget` a widget that allows to look for location with autocomplete
*  `StreamWeatherWidget` retrieve and show the weather by the given location coordinates
*  `WeatherIconWidget` is a helper widget to show [weather conditions code](https://openweathermap.org/weather-conditions)  as an emoji

1. It's possible to set up a default location before user starts to search*

2. As well as setting one 1 of 3 measurement units which are reffered in code as `WeatherUnitsType`:
    * `standard`
    * `metric`
    * `imperial`

Temperature is available in Fahrenheit, Celsius and Kelvin units.
Wind speed is available in miles/hour and meter/sec.

For temperature in Fahrenheit and wind speed in miles/hour, use unitsType=`imperial`
For temperature in Celsius and wind speed in meter/sec, use unitsType=`metric`
UnitsType=`standard` refers o OpenWeathegit statusrMap API behaviour: temperature in Kelvin and wind speed in meter/sec.