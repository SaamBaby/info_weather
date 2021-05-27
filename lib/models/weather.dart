

import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  final String main;
  final String description;
  final String icon;
  final int id;
  Weather( {this.main, this.description, this.icon, this.id});
  factory  Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}