class Favorite {
   int id;
  String placeId;
   String placeName;
  Favorite({this.id, this.placeId, this.placeName});

  Map<String , dynamic> toMap(){
    var map = <String, dynamic>{
      'id':id,
       'placeId':placeId,
        'placeName':placeName
    };
    return map;
  }

  Favorite.fromMap(Map<String, dynamic> map){
    id=map['id'];
    placeName=map['placeName'];
    placeId=map['placeId'];
  }

}