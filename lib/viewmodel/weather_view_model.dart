
import 'dart:async';
import 'package:aplikacja_pogodowa/model/weather.dart';
import 'package:aplikacja_pogodowa/repository/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherViewModel extends ChangeNotifier {
  final _repo = WeatherRepository();
  Weather? weather;
  bool isLoading = false;
  String city = 'Warsaw';

  Timer? _refresh;
  String? errorMessage;

  WeatherViewModel() {
    fetchWeather();
    _startAutoRefresh();
  }

   Future<void> fetchWeather() async {
    final apiKey = dotenv.env['WEATHER_API_KEY']!;
    final units = dotenv.env['UNITS'] ?? 'metric';
    isLoading = true;
    notifyListeners();

    final result = await _repo.getWeather(city, apiKey, units);
    if (result.isSuccess) {
      weather = result.data;
    } else {
      weather = null;
      errorMessage = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  void updateCity(String newCity) {
    if(newCity.trim().isEmpty) {
      return;
    }
    city = newCity.trim();
    fetchWeather();
  }

  void _startAutoRefresh(){
    _refresh?.cancel();
    _refresh = Timer.periodic(const Duration(minutes: 30), (timer) {
      fetchWeather();
    });
  }

  @override
  void dispose() {
    _refresh?.cancel();
    super.dispose();
  }
}