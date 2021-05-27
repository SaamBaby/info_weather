import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_weather/pages/weather.home.dart';
import 'package:provider/provider.dart';

import 'providers/weather.api.provider.dart';
final _weatherApiProvider =WeatherApiProvider();
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith
    (statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark, statusBarColor: Colors.white));
  runApp(
      ChangeNotifierProvider(
          create: (BuildContext context) =>_weatherApiProvider,
          child: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:Home()
    );
  }
}


