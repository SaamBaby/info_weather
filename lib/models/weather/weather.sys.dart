import 'package:json_annotation/json_annotation.dart';

part 'weather.sys.g.dart';

@JsonSerializable()
class WeatherSys {
  final int type;
  final int id;
  final double message;
  final String country;
  final int sunrise;
  final int sunset;

  WeatherSys({
    this.type, this.id, this.message, this.country, this.sunrise, this.sunset,
  });
  factory  WeatherSys.fromJson(Map<String, dynamic> json) =>
      _$WeatherSysFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherSysToJson(this);
}