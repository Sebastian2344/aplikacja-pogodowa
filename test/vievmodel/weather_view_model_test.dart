import 'package:aplikacja_pogodowa/helper/api_result.dart';
import 'package:aplikacja_pogodowa/model/clouds.dart';
import 'package:aplikacja_pogodowa/model/main_weather.dart';
import 'package:aplikacja_pogodowa/model/weather.dart';
import 'package:aplikacja_pogodowa/model/weather_icon.dart';
import 'package:aplikacja_pogodowa/repository/weather_repository.dart';
import 'package:aplikacja_pogodowa/viewmodel/weather_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherViewModel viewModel;
  late MockWeatherRepository mockRepo;

  setUp(() {
  mockRepo = MockWeatherRepository();
  
  // Mockujemy odpowiedź jeszcze przed utworzeniem ViewModel
  when(() => mockRepo.getWeather(any(), any(), any()))
      .thenAnswer((_) async => ApiResult.success(
        Weather(
          cityName: 'Warsaw',
          main: MainWeather(temp: 20, pressure: 1),
          clouds: Clouds(all: 1),
          weather: <WeatherIcon>[],
        ),
      ));

  dotenv.testLoad(fileInput: 'WEATHER_API_KEY=123\nUNITS=metric');
  viewModel = WeatherViewModel(mockRepo);
});

  test('fetchWeather sets weather on success', () async {
    final weather = Weather(
      cityName: 'Warsaw',
      main: MainWeather(temp: 20, pressure: 1),
      clouds: Clouds(all: 1),
      weather: <WeatherIcon>[]
    );
    when(() => mockRepo.getWeather(any(), any(), any()))
        .thenAnswer((_) async => ApiResult.success(weather));

    await viewModel.fetchWeather();

    expect(viewModel.isLoading, false);
    expect(viewModel.weather, weather);
    expect(viewModel.errorMessage, isNull);
  });

  test('fetchWeather sets errorMessage on failure', () async {
    when(() => mockRepo.getWeather(any(), any(), any()))
        .thenAnswer((_) async => ApiResult.failure('Błąd API'));

    await viewModel.fetchWeather();

    expect(viewModel.isLoading, false);
    expect(viewModel.weather, isNull);
    expect(viewModel.errorMessage, 'Błąd API');
  });

  test('updateCity updates city and fetches weather', () async {
    final weather = Weather(
      cityName: 'Warsaw',
      main: MainWeather(temp: 20, pressure: 1),
      clouds: Clouds(all: 1),
      weather: <WeatherIcon>[]
    );
    when(() => mockRepo.getWeather(any(), any(), any()))
        .thenAnswer((_) async => ApiResult.success(weather));

    viewModel.updateCity('Krakow');
    await Future.delayed(Duration.zero);

    expect(viewModel.city, 'Krakow');
    expect(viewModel.weather, weather);
  });

  test('updateCity ignores empty city', () {
    final oldCity = viewModel.city;
    viewModel.updateCity('   ');

    expect(viewModel.city, oldCity);
  });
}