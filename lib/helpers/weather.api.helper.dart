import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:info_weather/utils/constants.dart';


class WeatherApiHelper{



    Future<String> getWeather(LatLng location) async {
    final response = await http.get("https://api.openweathermap.org/data/2"
        ".5/weather?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=${Constants
        .openWeatherKey}");
    print("testing weather${response.body.toString()}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      return "failed";
      throw Exception('Failed to load weather');
    }
  }
}