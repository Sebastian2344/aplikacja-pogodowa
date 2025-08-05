// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainWeather _$MainWeatherFromJson(Map<String, dynamic> json) => MainWeather(
  temp: (json['temp'] as num).toDouble(),
  pressure: (json['pressure'] as num).toInt(),
);

Map<String, dynamic> _$MainWeatherToJson(MainWeather instance) =>
    <String, dynamic>{'temp': instance.temp, 'pressure': instance.pressure};
