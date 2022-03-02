import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/constant.dart';
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  // GET ALL MOVIE DATA INTO LIST //
  static Future<List<Map<String, dynamic>>> getData() async =>
      await userCollection.find().toList();

  // DATA QUERY //
  static Future<List<Map<String, dynamic>>> getIMDB_7() async =>
      await userCollection.find(where.gt("IMDB_Rating", 6.9)).toList();
  static Future<List<Map<String, dynamic>>> getIMDB_8() async =>
      await userCollection.find(where.gt("IMDB_Rating", 7.9)).toList();
  static Future<List<Map<String, dynamic>>> getIMDB_9() async =>
      await userCollection.find(where.gt("IMDB_Rating", 8.9)).toList();
  static Future<List<Map<String, dynamic>>> getLatest() async =>
      await userCollection.find(where.gt("Released_Year", 2019)).toList();
  static Future<List<Map<String, dynamic>>> getMustSee() async =>
      await userCollection.find(where.gt("Meta_score", 89)).toList();

  // INSERT //
  static Future<String> insert(MongoDbMovieModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong while inserting data!";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
