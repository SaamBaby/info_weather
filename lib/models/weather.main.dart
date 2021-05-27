

import 'package:json_annotation/json_annotation.dart';

part 'weather.main.g.dart';

@JsonSerializable()
class WeatherMain {
  final double temp;
  final  double feels_like;
  final double  temp_min;
  final  double temp_max;
  final int pressure;
  final int humidity;

  WeatherMain(
      {
        this.temp,
        this.feels_like,
        this.temp_min,
        this.temp_max,
        this.pressure,
      this.humidity});
  factory  WeatherMain.fromJson(Map<String, dynamic> json) =>
      _$WeatherMainFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherMainToJson(this);
}