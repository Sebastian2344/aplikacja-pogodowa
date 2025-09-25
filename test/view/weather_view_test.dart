import 'package:aplikacja_pogodowa/model/clouds.dart';
import 'package:aplikacja_pogodowa/model/main_weather.dart';
import 'package:aplikacja_pogodowa/model/rain.dart';
import 'package:aplikacja_pogodowa/model/weather.dart';
import 'package:aplikacja_pogodowa/model/weather_icon.dart';
import 'package:aplikacja_pogodowa/view/weather_view.dart';
import 'package:aplikacja_pogodowa/viewmodel/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockWeatherViewModel extends Mock implements WeatherViewModel {}

void main() {
  late MockWeatherViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockWeatherViewModel();
  });

  Widget _createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<WeatherViewModel>.value(
        value: mockViewModel,
        child: const WeatherView(),
      ),
    );
  }

  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    when(() => mockViewModel.isLoading).thenReturn(true);
    when(() => mockViewModel.errorMessage).thenReturn(null);
    when(() => mockViewModel.weather).thenReturn(null);

    await tester.pumpWidget(_createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when errorMessage is not null', (
    tester,
  ) async {
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn('Błąd API');
    when(() => mockViewModel.weather).thenReturn(null);

    await tester.pumpWidget(_createWidgetUnderTest());

    expect(find.text('Błąd API'), findsOneWidget);
  });

  testWidgets('shows weather data when weather is available', (tester) async {
    final weather = Weather(
      cityName: 'Krakow',
      main: MainWeather(temp: 20, pressure: 1012),
      clouds: Clouds(all: 50),
      weather: [WeatherIcon(icon: '01d', main: '', description: '')],
      rain: Rain(oneHour: 5),
    );

    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn(null);
    when(() => mockViewModel.weather).thenReturn(weather);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_createWidgetUnderTest());

      expect(find.text('Krakow'), findsOneWidget);
      expect(find.text('20.0°C'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('1012 hPa'), findsOneWidget);
      expect(find.text('5.0 mm'), findsOneWidget);
    });
  });

  testWidgets('TextField calls updateCity and fetchWeather', (tester) async {
    final weather = Weather(
      cityName: 'Warsaw',
      main: MainWeather(temp: 20, pressure: 1012),
      clouds: Clouds(all: 50),
      weather: [WeatherIcon(icon: '01d', main: '', description: '')],
      rain: Rain(oneHour: 5),
    );

    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn(null);
    when(() => mockViewModel.weather).thenReturn(weather);
    when(() => mockViewModel.updateCity(any())).thenReturn(null);
    when(() => mockViewModel.fetchWeather()).thenAnswer((_) async {});
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'Krakow');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(() => mockViewModel.updateCity('Krakow')).called(1);
      verify(() => mockViewModel.fetchWeather()).called(1);
    });
  });
}
