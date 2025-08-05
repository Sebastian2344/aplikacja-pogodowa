import 'package:aplikacja_pogodowa/view/weather_view.dart';
import 'package:aplikacja_pogodowa/viewmodel/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MultiProvider( 
    providers: [
      ChangeNotifierProvider(create: (_) => WeatherViewModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: WeatherView(),
    );
  }
}
