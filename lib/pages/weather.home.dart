import 'dart:async';

import 'package:flutter/services.dart'
      show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_weather/models/response.weather.dart';

import 'package:info_weather/providers/weather.api.provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String mapStyle;
  ResponseWeather responseWeather= ResponseWeather();
  Position _currentLocation;
  CameraPosition _currentCameraPosition;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController _googleMapController;
  CameraPosition _kGooglePlex = CameraPosition(
    // lastPosition??currentLocation??
    target: LatLng(43.653225, -79.383186),
    zoom: 14.4746,
  );

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    locateCurrentLocation().then((value) => {
      Provider.of<WeatherApiProvider>(context,listen: false).getCurrentLocationWeather(value)
    });
    super.initState();
  }
  void locateCurrentPosition() async {
    _googleMapController = await _controllerGoogleMap.future;
    locateCurrentLocation();
    LatLng latLngCurrentPosition = LatLng(_currentLocation.latitude, _currentLocation.longitude);
    _currentCameraPosition = new CameraPosition(target:  latLngCurrentPosition, zoom: 15);

    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
  }
  Future<Position> locateCurrentLocation() async {
    try{
      _currentLocation = await Geolocator.getCurrentPosition();
    }catch(e){
      print(e.toString());
    }
    return _currentLocation;
  }
  @override
  Widget build(BuildContext context) {
    var loadedData = Provider.of<WeatherApiProvider>(context).responseWeather;
    var size= MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: loadedData.name,
                  style: GoogleFonts.nunito(
                      color: Colors.black.withOpacity(.8),
                      fontSize: 30,
                      fontWeight: FontWeight.w900
                  ),
                ),
                TextSpan(
                  text: " . ${loadedData.sys.country}",
                  style: GoogleFonts.nunito(
                      color: Colors.black.withOpacity(.8),
                      fontSize: 30,
                      fontWeight: FontWeight.w900
                  ),
                )
              ]
            ),
          ),
        ),
        body: Container(

          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Center(
                 child: Text((DateFormat(' d . MMMM . yyyy').format(DateTime
                       .now())),
                     style: GoogleFonts.nunito(
                       color: Colors.black.withOpacity(.6),
                       fontSize: 16,
                       fontWeight: FontWeight.w600
                   ),),
                 ),

              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Stack(
                    children: [
                      Positioned(
                        child:
                        RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                  text:   loadedData.main.temp.round().toString(),
                                  style:  GoogleFonts.montserrat(
                                        color: Colors.black.withOpacity(.05),
                                          fontSize: size.width*.49,
                                          height: 1,
                                          fontWeight: FontWeight.w900
                                      ),
                                ),
                                TextSpan(
                                  text: "°C",
                                   style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(.05),
                                      fontSize: size.width*.49,
                                      height: 1,
                                      fontWeight: FontWeight.w900
                                      ),
                                )
                              ]
                          ),
                        ),

                      ),
                      Positioned(
                        top: 50,
                        left: 50,
                        child: SvgPicture.asset(
                            'assets/weather/001lighticons-08.svg',
                          height: 250,
                          width: 250,
                        )
                      ),
                      Positioned(
                          top: 100,
                          left: 200,
                          child: Text(loadedData.weather.first.main,style:
                          GoogleFonts
                              .montserrat(
                              color: Colors.black.withOpacity(.8),
                              fontSize: 18,
                              height: 1,
                              fontWeight: FontWeight.w500
                          ),),
                      ),
                      Positioned(
                        top: 120,
                        left: 200,
                        child:
                        RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Feels like ",
                                  style:  GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(.5),
                                      fontSize: 12,
                                      height: 1,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                TextSpan(
                                  text:   loadedData.main.feels_like.toString(),
                                  style:  GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(.5),
                                      fontSize: 12,
                                      height: 1,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                TextSpan(
                                  text: "°C",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(.5),
                                      fontSize: 13,
                                      height: 1,
                                      fontWeight: FontWeight.w500
                                  ),
                                )
                              ]
                          ),
                        ),

                      ),

                    ],
                  ),

                ),
              ),
              Center(
                child:Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height*.325,
                      child:   GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition:_kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          controller.setMapStyle(mapStyle);
                          _controllerGoogleMap.complete(controller);

                        },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            tileMode: TileMode.clamp,
                            begin: Alignment.center,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0x1AFFFFFF),Colors.white, Colors.white]),
                        color: Colors.white,
                      ),
                      child:Column(
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
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/wind.svg',color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:   loadedData.wind.speed.toString(),
                                            style:  GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 12,
                                                height: 1,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          TextSpan(
                                            text: "km/h",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 12,
                                                height: 1,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )
                                        ]
                                    ),
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
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/humidity.svg',color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  Text("81 %",style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700
                                  ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(.1)
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/weather/pressure.svg',color: Colors.black,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  Text("1041 hPa",style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700
                                  ),
                                  )
                                ],
                              ),


                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                    borderRadius: BorderRadius.only
                                      (topLeft: Radius.circular(10),bottomLeft:Radius.circular(10) ),),
                                  child: TextField(
                                    cursorColor: Colors.blue,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                        icon: Icon(
                                          Icons.search,
                                          size: 22,
                                          color: Colors.black,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only
                                            (topLeft: Radius.circular(10),bottomLeft:Radius.circular(10) ),
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only
                                            (topLeft: Radius.circular(10),bottomLeft:Radius.circular(10) ),
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                        hintText: "Search",
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.nunito(
                                            color: Colors.black.withOpacity(.6),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                        ),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontFamily: "Futura Book",
                                        letterSpacing: .8,
                                        height: 2,
                                        color: Colors.black.withOpacity(.6),
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,

                                decoration: BoxDecoration(

                                    borderRadius: BorderRadius.only
                                    (topRight: Radius.circular(10),
                                        bottomRight:Radius.circular(10) ),
                                    color: Colors.black),
                                child: IconButton(
                                      onPressed: (){},
                                      icon:Icon(
                                        Icons.favorite_outline_rounded,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                      )
                              )
                            ],
                          ),
                        ],
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }





}
