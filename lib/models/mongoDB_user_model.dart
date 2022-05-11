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
  });

  ObjectId id;
  String UUID;
  int age;
  String gender;
  String horoscope;

  factory MongoDBUserModel.fromJson(Map<String, dynamic> json) =>
      MongoDBUserModel(
        id: json["_id"],
        UUID: json["UUID"],
        age: json["age"],
        gender: json["gender"],
        horoscope: json["horoscope"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "UUID": UUID,
        "age": age,
        "gender": gender,
        "horoscope": horoscope,
      };
}
