// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
  cityName: json['name'] as String,
  main: MainWeather.fromJson(json['main'] as Map<String, dynamic>),
  clouds: Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
  rain: json['rain'] == null
      ? null
      : Rain.fromJson(json['rain'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => WeatherIcon.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'name': instance.cityName,
  'main': instance.main,
  'clouds': instance.clouds,
  'rain': instance.rain,
  'weather': instance.weather,
};
