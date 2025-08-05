import 'package:aplikacja_pogodowa/viewmodel/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pogoda'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCityInput(context, viewModel),
            const SizedBox(height: 20),
            Expanded(
              child: _buildWeatherContent(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityInput(BuildContext context, WeatherViewModel viewModel) {
    return TextField(
      onSubmitted: (value) {
        viewModel.updateCity(value);
        viewModel.fetchWeather();
      },
      decoration: InputDecoration(
        hintText: 'Wpisz miasto...',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!, style: TextStyle(color: Colors.red)));
    }

    final weather = viewModel.weather!;
    return ListView(
      children: [
        _buildWeatherCard(
          context,
          title: weather.cityName,
          icon: Icons.location_on,
          subtitle: 'Aktualna lokalizacja',
        ),
        _buildWeatherCard(
          context,
          title: '${weather.main.temp}°C',
          icon: Icons.thermostat,
          subtitle: 'Temperatura',
        ),
        _buildWeatherCard(
          context,
          title: '${weather.clouds.all}%',
          icon: Icons.cloud,
          subtitle: 'Zachmurzenie',
        ),
        _buildWeatherCard(
          context,
          title: '${weather.main.pressure} hPa',
          icon: Icons.speed,
          subtitle: 'Ciśnienie',
        ),
        _buildWeatherCard(
          context,
          title: '${weather.rain?.oneHour ?? 0} mm',
          icon: Icons.water_drop,
          subtitle: 'Opady',
        ),
        if (weather.weather[0].icon != null)
          _buildImageCard(context, weather.weather[0].icon), // OpenWeather icon
      ],
    );
  }

  Widget _buildWeatherCard(BuildContext context,
      {required String title, required IconData icon, required String subtitle}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String iconCode) {
    final iconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Image.network(iconUrl, width: 50, height: 50),
        title: const Text("Ikona pogody"),
        subtitle: Text('Kod: $iconCode'),
      ),
    );
  }
}