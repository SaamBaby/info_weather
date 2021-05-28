import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:info_weather/helpers/place.api.helper.dart';
import 'package:info_weather/helpers/sqflite/db.helper.dart';
import 'package:info_weather/models/place/user.favorite.dart';
import 'package:info_weather/models/weather/response.weather.dart';
import 'package:info_weather/pages/weather.home.dart';
import 'package:info_weather/providers/weather.api.provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SearchResult extends StatefulWidget {
  final String placeId;
  final bool isFavorite;

  const SearchResult({Key key, this.placeId, this.isFavorite}) : super(key: key);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool isLoaded =false;
  bool _isFavorite = false;
  String mapStyle;
  var dbHelper = FavoriteDbHelper();
  PlaceApiHelper placeApiHelper;
  ResponseWeather responseWeather = ResponseWeather();
  LatLng  coordinates;
  CameraPosition _currentCameraPosition;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController _googleMapController;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(43.653225, -79.383186),
    zoom: 14.4746,
  );

  @override
  void initState(){

    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    dbHelper.initDb();
    locateLocationCoordinate();
    isFavorite();
    super.initState();
  }

  void isFavorite(){
    dbHelper.readFvorite().then((value) => {
      value.forEach((element) {
        print(element.placeId);
        if(element.placeId==widget.placeId){
         setState(() {
       _isFavorite= true;
         });
        }
      })
    });
  }

  void setCurrentCameraPosition() async {
    _googleMapController = await _controllerGoogleMap.future;
    locateLocationCoordinate();
    // LatLng latLngCurrentPosition = LatLng(coordinates.latitude, coordinates.longitude);
    _currentCameraPosition = new CameraPosition(target: coordinates, zoom: 15);

    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
  }

  Future<LatLng> locateLocationCoordinate() async {

    try {
      placeApiHelper = PlaceApiHelper(Uuid().v4());

      placeApiHelper.getPlaceCoordinatesFromId(widget.placeId).then((value) => {
      setState(() {
        coordinates=LatLng(value.latitude, value.longitude);
        isLoaded= true;
        if(isLoaded)
        Provider.of<WeatherApiProvider>(context, listen: false).getCurrentLocationWeather(coordinates);

       }),
      });
    } catch (e) {
      print(e.toString());
    }

    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    var loadedData = Provider.of<WeatherApiProvider>(context).responseWeather;
    var size = MediaQuery.of(context).size;
    return (!isLoaded)? Container(
      color: Colors.white,
      width: size.width,
      height: size.height,
      child:  new Center(child: new CircularProgressIndicator
        (valueColor:AlwaysStoppedAnimation<Color>(Colors.black),)),
    ):SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading:IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
               if(!_isFavorite){
                  var data= Favorite(placeId:widget.placeId,placeName: loadedData.name);
                 dbHelper.createFavourite(data).then((value) =>print
                   ("favorite added$value") );

               }
              },
              icon: Icon(
                _isFavorite?Icons.favorite:Icons.favorite_outline_rounded,
                size: 22,
                color:_isFavorite?Colors.red: Colors.black,
              ),
            ),
          ],
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: loadedData.name,
                style: GoogleFonts.nunito(
                    color: Colors.black.withOpacity(.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              TextSpan(
                text: " . ${loadedData.sys.country}",
                style: GoogleFonts.nunito(
                    color: Colors.black.withOpacity(.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              )
            ]),
          ),
          toolbarHeight: 70,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                (DateFormat(' d . MMMM . yyyy').format(DateTime.now())),
                style: GoogleFonts.nunito(
                    color: Colors.black.withOpacity(.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: loadedData.main.temp.round().toString(),
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(.05),
                                fontSize: size.width * .49,
                                height: 1,
                                fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                            text: "°C",
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(.05),
                                fontSize: size.width * .49,
                                height: 1,
                                fontWeight: FontWeight.w900),
                          )
                        ]),
                      ),
                    ),
                    Positioned(
                        top: 50,
                        left: 50,
                        child: SvgPicture.asset(
                          'assets/weather/001lighticons-08.svg',
                          height: 250,
                          width: 250,
                        )),
                    Positioned(
                      top: 100,
                      left: 200,
                      child: Text(
                        loadedData.weather.first.description[0]
                            .toUpperCase() +
                            loadedData.weather.first.description.substring(1),
                        style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(.8),
                            fontSize: 18,
                            height: 1,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 200,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Feels like ",
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 12,
                                height: 1,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: loadedData.main.feels_like.toString(),
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 12,
                                height: 1,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: "°C",
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 13,
                                height: 1,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height * .325,
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(mapStyle);
                        _controllerGoogleMap.complete(controller);
                      },
                    ),
                  ),
                  Container(
                      height: size.height * .25,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            tileMode: TileMode.clamp,
                            begin: Alignment.center,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0x1AFFFFFF),
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white
                            ]),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/wind.svg',
                                        color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                        loadedData.wind.speed.toString(),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: "km/h",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/sunset.svg',
                                        color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                        loadedData.wind.speed.toString(),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: "km/h",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/humidity.svg',
                                        color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: loadedData.main.humidity
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: "%",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/pressure.svg',
                                        color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: loadedData.main.pressure
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: " hPa",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/sunrise.svg',
                                        color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                        loadedData.wind.speed.toString(),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: "km/h",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                                  ),
                                ],
                              ),

                            ],
                          ),


                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
