// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$QueryWeatherByDateRequestToJson(
        QueryWeatherByDateRequest instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hashCode': instance.hashCode,
      'dt': instance.dt,
      'lat': instance.lat,
      'lon': instance.lon,
      'appid': instance.appId,
      'units': _$WeatherUnitsTypeEnumMap[instance.units],
      'props': instance.props,
    };

const _$WeatherUnitsTypeEnumMap = {
  WeatherUnitsType.standard: 'standard',
  WeatherUnitsType.metric: 'metric',
  WeatherUnitsType.imperial: 'imperial',
};

Map<String, dynamic> _$QueryCoordinatesByLocationNameRequestToJson(
        QueryCoordinatesByLocationNameRequest instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hashCode': instance.hashCode,
      'q': instance.q,
      'appid': instance.appId,
      'limit': instance.limit,
      'props': instance.props,
    };
