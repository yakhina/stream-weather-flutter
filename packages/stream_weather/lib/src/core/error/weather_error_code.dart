import 'package:stream_weather/src/core/util/utils.dart';

/// Error code for weather API and Weather SDK
enum WeatherErrorCode {
  /// API Key is not defined
  undefinedAPIKey,

  /// Number of calls to the API exceeded the limit
  numberOfCallsExceeded,
}

const _errorCodeWithDescription = {
  WeatherErrorCode.undefinedAPIKey:
      MapEntry(1000, 'API Key is not defined'),
  WeatherErrorCode.numberOfCallsExceeded:
      MapEntry(429, 'Number of calls to the API exceeded the limit'),
};

const _authenticationErrors = [
  WeatherErrorCode.undefinedAPIKey,
  WeatherErrorCode.numberOfCallsExceeded,
];

///
WeatherErrorCode? weathertErrorFromCode(int code) => _errorCodeWithDescription.keys
    .firstWhereOrNull((key) => _errorCodeWithDescription[key]!.key == code);

///
extension WeatherErrorCodeX on WeatherErrorCode {
  ///
  String get message => _errorCodeWithDescription[this]!.value;

  ///
  int get code => _errorCodeWithDescription[this]!.key;

  ///
  bool get isAuthenticationError => _authenticationErrors.contains(this);
}