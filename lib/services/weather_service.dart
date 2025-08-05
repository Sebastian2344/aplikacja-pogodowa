import 'package:aplikacja_pogodowa/model/weather.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'weather_service.g.dart';

@RestApi()
abstract class WeatherService {
  factory WeatherService(Dio dio, {String baseUrl}) = _WeatherService;

  @GET('/data/2.5/weather')
  Future<Weather> getWeather(
    @Query('q') String city,
    @Query('appid') String apiKey,
    @Query('units') String units,
  );
}