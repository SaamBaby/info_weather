
import 'package:http/http.dart' as http;
import 'package:info_weather/models/place/place.coordinates.dart';
import 'dart:convert';
import 'package:info_weather/models/place/place.suggestion.dart';
import 'package:info_weather/utils/constants.dart';

class PlaceApiHelper {
  PlaceApiHelper(this.sessionToken);
  final sessionToken;
  Future<List<Suggestion>> getAllSuggestions(String input) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=${Constants.androidKey}&sessiontoken=$sessionToken';

    final response = await http.get(request);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('There was some un expected error, please check the your '
          'internet connection and try again');
    }
  }
  Future<PlaceCoordinates> getPlaceCoordinatesFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=${Constants.androidKey}&sessiontoken=$sessionToken';
    final response = await http.get(request);
    if (response.statusCode == 200) {
      print("testing place${response.body.toString()}");
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components = result['result']['geometry']['location'];
        var place = PlaceCoordinates();
        place.latitude =components['lat'];
        place.longitude=components['lng'];
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

}