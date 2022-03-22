// To parse this JSON data, do
//
//     final mongoDbMovieModel = mongoDbMovieModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

RecipeModel mongoDbRecipeModelFromJson(String str) =>
    RecipeModel.fromJson(json.decode(str));

String mongoDbRecipeModelToJson(RecipeModel data) => json.encode(data.toJson());

class RecipeModel {
  RecipeModel({
    required this.id,
    required this.image,
    required this.calories,
    required this.url,
    required this.label,
    required this.ingredients,
    required this.mealType,
    required this.totalTime,
    required this.dishType,
  });

  ObjectId id;
  String? image;
  double calories;
  String url;
  String? label;
  List ingredients;
  String mealType;
  double totalTime;
  List dishType;

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["_id"],
        image: json["image"],
        calories: json["calories"],
        url: json["url"],
        label: json["label"],
        ingredients: json["ingredients"],
        mealType: json["mealType"],
        totalTime: json["totalTime"],
        dishType: json["dishType"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "calories": calories,
        "url": url,
        "label": label,
        "ingredients": ingredients,
        "mealType": mealType,
        "totalTime": totalTime,
        "dishType": dishType
      };
}
