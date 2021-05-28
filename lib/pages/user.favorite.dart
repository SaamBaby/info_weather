import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_weather/helpers/sqflite/db.helper.dart';
import 'package:info_weather/models/place/user.favorite.dart';
import 'package:info_weather/pages/weather.home.dart';
import 'package:info_weather/pages/weather.search.result.dart';

class UserFavorites extends StatefulWidget {

  @override
  _UserFavoritesState createState() => _UserFavoritesState();
}

class _UserFavoritesState extends State<UserFavorites> {
  Future<List<Favorite>> favorites;
  // List.generate(taskMap.length, (index) {
  // return Task(id: taskMap[index]['id'],
  // title: taskMap[index]['title'],
  // desc: taskMap[index]['desc']);
  // });
  var dbHelper = FavoriteDbHelper();
   @override
  void initState() {
     dbHelper.initDb();
     getAllFavorites();
    super.initState();
  }
  void getAllFavorites() {

    setState(() {
      favorites= dbHelper.readFvorite();
    });
  }
  @override
  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
      return true; // return true if the route to be popped
    }

    return  WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "My",
                style: GoogleFonts.nunito(
                    color: Colors.black.withOpacity(.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              TextSpan(
                text: " . Locations",
                style: GoogleFonts.nunito(
                    color: Colors.black.withOpacity(.8),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              )
            ]),
          ),
        ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            margin: EdgeInsets.symmetric(vertical: 5,),
            child:Column(
              children: [
                Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: favorites,
                      builder: (context, snapshot){
                        return snapshot.hasData? listViewBuild(
                          snapshot.data,
                        ):snapshot.data==null?
                        Text("No favorites yet"): CircularProgressIndicator();
                      },
                    )
                )
              ],
            ),
          )
      ),
    );
  }

   listViewBuild(List<dynamic> favorites ){
     return ListView.separated(
       itemBuilder: (context, index) => Card(
         child: ListTile(
           leading: CircleAvatar(
               backgroundColor: Colors.white,
               child: Icon(
                 Icons.location_on,
                 size: 30,
                 color: Colors.blue,
               )),
           trailing: Icon(
             Icons.arrow_forward,
             size: 20,
             color: Colors.black.withOpacity(.8),
           ),
           title: Text(
             ( favorites[index].placeName),
             style: GoogleFonts.montserrat(
                 color: Colors.black.withOpacity(.8),
                 fontSize: 16,
                 letterSpacing: 1,
                 height: 1.3,
                 fontWeight: FontWeight.w500),
           ),
           onTap: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context)
             =>SearchResult(placeId:  favorites[index].placeId.toString() )));
           },
         ),
       ),
       physics: NeverScrollableScrollPhysics(),
       shrinkWrap: true,
       separatorBuilder: (context, index) => Padding(
         padding: EdgeInsets.symmetric(horizontal: 16),
         child: Divider(),
       ),
       itemCount: favorites.length,
     );
  }

}
