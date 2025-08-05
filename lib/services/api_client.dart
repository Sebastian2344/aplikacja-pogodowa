import 'package:aplikacja_pogodowa/services/weather_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );
    static final WeatherService weatherService = 
    WeatherService(_dio,
     baseUrl: dotenv.env['BASE_URL']!);
}