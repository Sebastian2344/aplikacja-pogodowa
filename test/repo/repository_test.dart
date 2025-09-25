import 'package:aplikacja_pogodowa/model/clouds.dart';
import 'package:aplikacja_pogodowa/model/main_weather.dart';
import 'package:aplikacja_pogodowa/model/weather.dart';
import 'package:aplikacja_pogodowa/model/weather_icon.dart';
import 'package:aplikacja_pogodowa/repository/weather_repository.dart';
import 'package:aplikacja_pogodowa/services/api_client.dart';
import 'package:aplikacja_pogodowa/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  late WeatherRepository repository;
  late MockWeatherService mockService;

  setUp(() {
    mockService = MockWeatherService();
    ApiClient.weatherService = mockService;
    repository = WeatherRepository();
  });

  test('should return success when API call succeeds', () async {
    final weather = Weather(
      cityName: 'Warsaw',
      main: MainWeather(temp: 20, pressure: 1),
      clouds: Clouds(all: 1),
      weather: <WeatherIcon>[]
    ); // przykładowy obiekt
    when(
      () => mockService.getWeather(any(), any(), any()),
    ).thenAnswer((_) async => weather);

    final result = await repository.getWeather('Warsaw', 'apiKey', 'metric');

    expect(result.isSuccess, true);
    expect(result.data, weather);
  });

  test(
    'should return failure with proper message on SocketException',
    () async {
      when(
        () => mockService.getWeather(any(), any(), any()),
      ).thenThrow(SocketException('No Internet'));

      final result = await repository.getWeather('Warsaw', 'apiKey', 'metric');

      expect(result.isSuccess, false);
      expect(result.error, 'Brak połączenia z internetem.');
    },
  );

  test(
    'should return failure with proper message on DioException badResponse 404',
    () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        () => mockService.getWeather(any(), any(), any()),
      ).thenThrow(dioError);

      final result = await repository.getWeather(
        'UnknownCity',
        'apiKey',
        'metric',
      );

      expect(result.isSuccess, false);
      expect(result.error, 'Nie znaleziono miasta (404).');
    },
  );
  test(
    'should return failure with proper message on DioException badResponse 500',
    () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        () => mockService.getWeather(any(), any(), any()),
      ).thenThrow(dioError);

      final result = await repository.getWeather(
        'UnknownCity',
        'apiKey',
        'metric',
      );

      expect(result.isSuccess, false);
      expect(result.error, 'Błąd serwera (500).');
    },
  );

  test(
    'should return failure with proper message on DioException connectionTimeout',
    () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );

      when(
        () => mockService.getWeather(any(), any(), any()),
      ).thenThrow(dioError);

      final result = await repository.getWeather(
        'UnknownCity',
        'apiKey',
        'metric',
      );

      expect(result.isSuccess, false);
      expect(result.error, 'Połączenie z serwerem wygasło.');
    },
  );
}
