import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/constant.dart';

// MONGODB RECIPE DATA MANIPULATION
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
  static Future<List<Map<String, dynamic>>> getBreakfast() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Breakfast").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> get60Mins() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "< 60 Mins").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getDessert() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Dessert").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getVegetable() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Vegetable").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getBeverages() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Beverages").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getSauces() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Sauces").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getChicken() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Chicken").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getLowCal() async =>
      await userCollection
          .find(where.lt("Calories", 100).gt("Calories", 1).limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getHighRating() async =>
      await userCollection
          .find(where.gt("AggregatedRating", 4.5).limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getMostReviewed() async =>
      await userCollection.find(where.gt("ReviewCount", 50).limit(50)).toList();

  static Future<List<Map<String, dynamic>>> get1Serving() async =>
      await userCollection
          .find(where.eq("RecipeServings", 1).limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> get30Min() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "< 30 Mins").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> get15Min() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "< 15 Mins").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getMeat() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Meat").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getLunch() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Lunch/Snacks").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getBread() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Breads").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getHealthy() async =>
      await userCollection
          .find(where.eq("RecipeCategory", "Healthy").limit(50))
          .toList();

  static Future<List<Map<String, dynamic>>> getSearched(String word) async =>
      await userCollection
          .find(where.eq("RecipeCategory", word).limit(20))
          .toList();

  static Future<List<Map<String, dynamic>>> getRandom(int random) async {
    return await userCollection
        .find(where.eq("RecipeCategory", recipeCategories[random]).limit(100))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getRecipe(String name) async =>
      await userCollection.find(where.eq("Name", name)).toList();
}
