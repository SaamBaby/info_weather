import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_weather/helpers/place.api.helper.dart';
import 'package:info_weather/models/place/place.suggestion.dart';
import 'package:info_weather/pages/weather.search.result.dart';

class AddressDataSearch extends SearchDelegate<String> {
  final sessionToken;
  PlaceApiHelper placeApiHelper;

  AddressDataSearch(this.sessionToken)
      : super(
            searchFieldLabel: "Search here",
            searchFieldStyle: GoogleFonts.montserrat(
                color: Colors.black.withOpacity(.4),
                fontSize: 16,
                letterSpacing: 1,
                height: 1,
                fontWeight: FontWeight.w500)) {
    placeApiHelper = PlaceApiHelper(sessionToken);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //Actions for app bar
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black.withOpacity(.8),
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          color: Colors.black.withOpacity(.8),
          progress: transitionAnimation,
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something

    return FutureBuilder(
      future: query.isEmpty ? null : placeApiHelper.getAllSuggestions(query),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
          query.isEmpty
              ? ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black.withOpacity(.8),
                        size: 20,
                      )),
                  title: Text("No keywords",
                      style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(.8),
                          fontSize: 16,
                          letterSpacing: 1,
                          height: 1,
                          fontWeight: FontWeight.w500)),
                  onTap: () {},
                )
              : snapshot.hasData
                  ? ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.black,
                            )),
                        title: Text(
                          ((snapshot.data[index] as Suggestion).placeName),
                          style: GoogleFonts.montserrat(
                              color: Colors.black.withOpacity(.8),
                              fontSize: 16,
                              letterSpacing: 1,
                              height: 1.3,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute
                            (builder: (context)=>SearchResult(placeId: (snapshot.data[index] as Suggestion).placeId.toString() )));
                        },
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(),
                      ),
                      itemCount: snapshot.data.length,
                    )
                  : ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.alarm_outlined,
                            color: Colors.black.withOpacity(.4),
                            size: 20,
                          )),
                      title: Text("Searching"),
                      onTap: () {},
                    ),
    );
  }
}
