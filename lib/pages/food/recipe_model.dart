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
    required this.name,
    required this.image,
    required this.calories,
    required this.ingredients,
    required this.recipeCategory,
    required this.rating,
    required this.reviewCount,
    required this.servings,
    required this.description,
  });

  ObjectId id;
  String name;
  String? image;
  double calories;
  String ingredients;
  String recipeCategory;
  double rating;
  int reviewCount;
  int servings;
  String description;

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["_id"],
        name: json["Name"],
        image: json["Images"],
        calories: json["Calories"],
        ingredients: json["RecipeIngredientParts"],
        recipeCategory: json["RecipeCategory"],
        rating: json["AggregatedRating"],
        reviewCount: json["ReviewCount"],
        servings: json["RecipeServings"],
        description: json["RecipeInstructions"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "calories": calories,
        "ingredients": ingredients,
        "recipeCategory": recipeCategory,
        "rating": rating,
        "reviewCount": reviewCount,
        "servings": servings,
        "description": description,
      };
}
