import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:info_weather/models/response.weather.dart';


class WeatherApiHelper{

  final _apiKey = 'e8e244d6709e2a9417acd59110c3bd85';

  Future<String> getWeather(Position location) async {
    final response = await http.get("https://api.openweathermap.org/data/2"
        ".5/weather?lat=42.995100&lon=-81.281500&units=metric&appid=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      return "failed";
      throw Exception('Failed to load weather');
    }
  }
}