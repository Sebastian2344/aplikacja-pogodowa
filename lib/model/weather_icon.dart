import 'package:json_annotation/json_annotation.dart';

part 'weather_icon.g.dart';

@JsonSerializable()
class WeatherIcon {
  final String icon;
  final String description;
  final String main;

  WeatherIcon({
    required this.icon,
    required this.description,
    required this.main,
  });

  factory WeatherIcon.fromJson(Map<String, dynamic> json) =>
      _$WeatherIconFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherIconToJson(this);
}