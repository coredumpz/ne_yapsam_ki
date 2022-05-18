// To parse this JSON data, do
//
//     final MongoDBUserModel = MongoDBUserModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDBUserModel MongoDBUserModelFromJson(String str) =>
    MongoDBUserModel.fromJson(json.decode(str));

String MongoDBUserModelToJson(MongoDBUserModel data) =>
    json.encode(data.toJson());

class MongoDBUserModel {
  MongoDBUserModel({
    required this.id,
    required this.UUID,
    required this.age,
    required this.gender,
    required this.horoscope,
    required this.movieFav,
    required this.seriesFav,
    required this.bookFav,
    required this.recipeFav,
    required this.gameFav,
  });

  ObjectId id;
  String UUID;
  int age;
  String gender;
  String horoscope;
  List movieFav;
  List seriesFav;
  List bookFav;
  List recipeFav;
  List gameFav;

  factory MongoDBUserModel.fromJson(Map<String, dynamic> json) =>
      MongoDBUserModel(
        id: json["_id"],
        UUID: json["UUID"],
        age: json["age"],
        gender: json["gender"],
        horoscope: json["horoscope"],
        movieFav: json["movieFav"],
        seriesFav: json["seriesFav"],
        bookFav: json["bookFav"],
        recipeFav: json["recipeFav"],
        gameFav: json["gameFav"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "UUID": UUID,
        "age": age,
        "gender": gender,
        "horoscope": horoscope,
        "movieFav": movieFav,
        "seriesFav": seriesFav,
        "bookFav": bookFav,
        "recipeFav": recipeFav,
        "gameFav": gameFav,
      };
}
