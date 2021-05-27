// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseWeather _$ResponseWeatherFromJson(Map<String, dynamic> json) {
  return ResponseWeather(
    wind: json['wind'] == null
        ? null
        : Wind.fromJson(json['wind'] as Map<String, dynamic>),
    name: json['name'] as String,
    weather: (json['weather'] as List)
        ?.map((e) =>
            e == null ? null : Weather.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    id: json['id'] as int,
    sys: json['sys'] == null
        ? null
        : WeatherSys.fromJson(json['sys'] as Map<String, dynamic>),
    visibility: json['visibility'] as int,
    main: json['main'] == null
        ? null
        : WeatherMain.fromJson(json['main'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResponseWeatherToJson(ResponseWeather instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visibility': instance.visibility,
      'main': instance.main,
      'weather': instance.weather,
      'name': instance.name,
      'sys': instance.sys,
      'wind': instance.wind,
    };
