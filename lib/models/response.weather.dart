

import 'package:info_weather/models/weather.dart';
import 'package:info_weather/models/weather.main.dart';
import 'package:info_weather/models/weather.sys.dart';
import 'package:info_weather/models/weather.wind.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.weather.g.dart';

@JsonSerializable()
class ResponseWeather {
  final int id;
  final int visibility;
  final WeatherMain main;
  final List<Weather> weather;
  final String name;
  final WeatherSys sys;
  final Wind wind;

  ResponseWeather( {this.wind, this.name,this.weather,this.id,this.sys, this
      .visibility,
    this
      .main});
  factory  ResponseWeather.fromJson(Map<String, dynamic> json) =>
      _$ResponseWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseWeatherToJson(this);
}