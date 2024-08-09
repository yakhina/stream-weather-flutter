// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse()
      ..duration = json['duration'] as String?
      ..code = (json['code'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..statusCode = (json['statusCode'] as num?)?.toInt()
      ..moreInfo = json['moreInfo'] as String?;

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'code': instance.code,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'moreInfo': instance.moreInfo,
    };

QueryWeatherByDateResponse _$QueryWeatherByDateResponseFromJson(
        Map<String, dynamic> json) =>
    QueryWeatherByDateResponse()
      ..duration = json['duration'] as String?
      ..lat = (json['lat'] as num?)?.toDouble()
      ..lon = (json['lon'] as num?)?.toDouble()
      ..timezone = json['timezone'] as String?
      ..timezoneOffset = (json['timezone_offset'] as num?)?.toInt()
      ..data = (json['data'] as List<dynamic>)
          .map((e) => WeatherData.fromJson(e as Map<String, dynamic>))
          .toList();

QueryCoordinatesByLocationNameResponse
    _$QueryCoordinatesByLocationNameResponseFromJson(
            Map<String, dynamic> json) =>
        QueryCoordinatesByLocationNameResponse()
          ..duration = json['duration'] as String?
          ..data = (json['data'] as List<dynamic>?)
              ?.map((e) => Location.fromJson(e as Map<String, dynamic>))
              .toList();
