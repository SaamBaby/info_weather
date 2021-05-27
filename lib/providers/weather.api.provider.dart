
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:info_weather/helpers/weather.api.helper.dart';
import 'package:info_weather/models/response.weather.dart';



class WeatherApiProvider  extends ChangeNotifier{
  WeatherApiHelper _weatherApiHelper=WeatherApiHelper();
 ResponseWeather  responseWeather;

  Future<void> getCurrentLocationWeather(Position location){
    _weatherApiHelper.getWeather(location).then((value) => {
      if(value!='failed'){
        responseWeather= ResponseWeather.fromJson(json.decode(value))
      }
    });
    return null;
  }

}