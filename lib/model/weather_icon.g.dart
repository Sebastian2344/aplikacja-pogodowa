// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_icon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherIcon _$WeatherIconFromJson(Map<String, dynamic> json) => WeatherIcon(
  icon: json['icon'] as String,
  description: json['description'] as String,
  main: json['main'] as String,
);

Map<String, dynamic> _$WeatherIconToJson(WeatherIcon instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'description': instance.description,
      'main': instance.main,
    };
