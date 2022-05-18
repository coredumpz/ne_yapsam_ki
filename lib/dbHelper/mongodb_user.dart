import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ne_yapsam_ki/dbHelper/constant.dart';
import 'package:ne_yapsam_ki/models/mongoDB_user_model.dart';

class MongoDBInsert {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection("users");
  }

  static Future<String> insert(MongoDBUserModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something went wrong while inserting data.";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // MONGODB FAV PARTS

  // Movie Favorite
  static Future<void> updateMovies(String uid, int moviesID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.addToSet('movieFav', moviesID));
  }

  static Future<bool> checkMovies(String uid, int moviesID) async {
    var result = await userCollection
        .find(where.eq('UUID', uid).and(where.eq("movieFav", moviesID)))
        .toList();
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteMovies(String uid, int moviesID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.pull('movieFav', moviesID));
  }

  // Series Favorite
  static Future<void> updateSeries(String uid, int seriesID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.addToSet('seriesFav', seriesID));
  }

  static Future<bool> checkSeries(String uid, int seriesID) async {
    var result = await userCollection
        .find(where.eq('UUID', uid).and(where.eq("seriesFav", seriesID)))
        .toList();
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteSeries(String uid, int seriesID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.pull('seriesFav', seriesID));
  }

  // Book Favorite
  static Future<void> updateBook(String uid, String bookID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.addToSet('bookFav', bookID));
  }

  static Future<bool> checkBook(String uid, String bookID) async {
    var result = await userCollection
        .find(where.eq('UUID', uid).and(where.eq("bookFav", bookID)))
        .toList();
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteBook(String uid, String bookID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.pull('bookFav', bookID));
  }

  // Recipe Favorite
  static Future<void> updateRecipe(String uid, String name) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.addToSet('recipeFav', name));
  }

  static Future<bool> checkRecipe(String uid, String name) async {
    var result = await userCollection
        .find(where.eq('UUID', uid).and(where.eq("recipeFav", name)))
        .toList();
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteRecipe(String uid, String name) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.pull('recipeFav', name));
  }

  // Game Favorite

  static Future<void> updateGame(String uid, int gameID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.addToSet('gameFav', gameID));
  }

  static Future<bool> checkGame(String uid, int gameID) async {
    var result = await userCollection
        .find(where.eq('UUID', uid).and(where.eq("gameFav", gameID)))
        .toList();
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<void> deleteGame(String uid, int gameID) async {
    await userCollection.update(
        where.eq('UUID', uid), modify.pull('gameFav', gameID));
  }

  // RETRIEVE FAVORITE & USER INFORMATION LISTS

  static Future<List<Map<String, dynamic>>> userData(String uid) async {
    return await userCollection.find(where.eq("UUID", uid)).toList();
  }
}
