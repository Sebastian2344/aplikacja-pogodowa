import 'package:json_annotation/json_annotation.dart';

part 'main_weather.g.dart';

@JsonSerializable()
class MainWeather {
  final double temp;
  final int pressure;

  MainWeather({
    required this.temp,
    required this.pressure,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) =>
      _$MainWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$MainWeatherToJson(this);
}