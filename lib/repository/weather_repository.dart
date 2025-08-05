import 'dart:io';

import 'package:aplikacja_pogodowa/helper/api_result.dart';
import 'package:aplikacja_pogodowa/model/weather.dart';
import 'package:aplikacja_pogodowa/services/api_client.dart';
import 'package:dio/dio.dart';

class WeatherRepository {
  Future<ApiResult<Weather>> getWeather(String city, String apiKey, String units) async {
    try {
      final response = await ApiClient.weatherService.getWeather(city, apiKey, units);
      return ApiResult.success(response);
    } on DioException catch (e) {
      String message = _handleDioError(e);
      return ApiResult.failure(message);
    } on SocketException {
      return ApiResult.failure("Brak połączenia z internetem.");
    } on FormatException {
      return ApiResult.failure("Błąd formatu danych.");
    } catch (e) {
      return ApiResult.failure("Nieoczekiwany błąd: ${e.toString()}");
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Połączenie z serwerem wygasło.";
      case DioExceptionType.sendTimeout:
        return "Wysyłanie żądania trwało zbyt długo.";
      case DioExceptionType.receiveTimeout:
        return "Czekanie na odpowiedź serwera trwało zbyt długo.";
      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response?.statusCode);
      case DioExceptionType.cancel:
        return "Żądanie zostało anulowane.";
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return "Brak internetu.";
        }
        return "Nieznany błąd sieci.";
      default:
        return "Wystąpił błąd: ${e.message}";
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Nieprawidłowe żądanie (400).";
      case 401:
        return "Błąd autoryzacji (401) – sprawdź API key.";
      case 403:
        return "Brak dostępu (403).";
      case 404:
        return "Nie znaleziono miasta (404).";
      case 429:
        return "Zbyt wiele zapytań – spróbuj później (429).";
      case 500:
        return "Błąd serwera (500).";
      default:
        return "Błąd serwera (${statusCode ?? 'brak kodu'}).";
    }
  }
}