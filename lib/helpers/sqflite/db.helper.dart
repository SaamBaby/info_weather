import 'dart:io' as io;
import 'dart:async';
import 'package:info_weather/models/place/user.favorite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteDbHelper{
  static Database _db;
  static const String ID ='id';
  static  const String PLACE_ID   ='placeId';
  static const String PLACE_NAME='placeName';
  static const String TABLE ='Favorite';
  static const String DB_NAME='infoWeather.db';

  Future<Database> get db  async{
    if(_db !=null){
      return _db;
    }else
      {
        _db= await initDb();
        return _db;
      }
  }

  initDb()async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version:1, onCreate: _onCreate);
    return db;
  }




  void _onCreate(Database db, int version)  async{
    await db.execute("CREATE TABLE"
        " $TABLE("
        "$ID TEXT PRIMARY KEY, "
        "$PLACE_ID TEXT, "
        "$PLACE_NAME TEXT)");
  }

  Future<int> createFavourite( Favorite favorite)async{
    var dbClient = await db;
     var response = await dbClient.insert(TABLE, favorite.toMap());
     return response;
  }
   Future<List<Favorite>> readFvorite() async{
     var dbClient = await db;
     List<Map> maps = await dbClient.query(TABLE, columns: [ID,PLACE_NAME,
       PLACE_ID]);
     List<Favorite> favorites = [];
     if(maps.length>0){
       for(int i =0; i<maps.length;i++){
         favorites.add((Favorite.fromMap(maps[i])));
       }
       return favorites;
     }

     // database update

     // database delete

     Future close () async{
       var dbClient = await db;
       dbClient.close; 

     }

   }
}