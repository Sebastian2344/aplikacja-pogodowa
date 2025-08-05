import 'package:aplikacja_pogodowa/model/clouds.dart';
import 'package:aplikacja_pogodowa/model/main_weather.dart';
import 'package:aplikacja_pogodowa/model/rain.dart';
import 'package:aplikacja_pogodowa/model/weather_icon.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  @JsonKey(name: 'name')
  final String cityName;

  @JsonKey(name: 'main')
  final MainWeather main;

  @JsonKey(name: 'clouds')
  final Clouds clouds;

  @JsonKey(name: 'rain')
  final Rain? rain;

  @JsonKey(name: 'weather')
  final List<WeatherIcon> weather;

  Weather({
    required this.cityName,
    required this.main,
    required this.clouds,
    this.rain,
    required this.weather,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
