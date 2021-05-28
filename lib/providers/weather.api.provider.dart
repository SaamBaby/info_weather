
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:info_weather/helpers/weather.api.helper.dart';
import 'package:info_weather/models/weather/response.weather.dart';




class WeatherApiProvider  extends ChangeNotifier{
  WeatherApiHelper _weatherApiHelper=WeatherApiHelper();
 ResponseWeather  responseWeather;

  Future<ResponseWeather> getCurrentLocationWeather(LatLng location){
    _weatherApiHelper.getWeather(location).then((value) => {
      if(value!='failed'){
        responseWeather= ResponseWeather.fromJson(json.decode(value)),
        notifyListeners()
      }
    });
    notifyListeners();
    return Future.delayed(Duration(seconds: 1)).then((value) =>responseWeather );
  }

}