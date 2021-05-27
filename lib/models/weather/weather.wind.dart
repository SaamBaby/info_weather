import 'package:json_annotation/json_annotation.dart';
part 'weather.wind.g.dart';

@JsonSerializable()
class Wind {
  final double speed;
  final int deg;
  final double gust;
  Wind({this.speed, this.deg, this.gust,  });
  factory  Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  Map<String, dynamic> toJson() => _$WindToJson(this);
}