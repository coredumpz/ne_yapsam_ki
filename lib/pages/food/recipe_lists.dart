import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_detail.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';
import 'package:http/http.dart' as http;

import '../../dbHelper/mongodb.dart';

class RecipeList extends StatefulWidget {
  String mealType;

  RecipeList({Key? key, required this.mealType}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<RecipeModel> recipeList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mealType.toUpperCase(),
            style: GoogleFonts.mcLaren(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: mongoMethod(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  print(
                      widget.mealType + "= " + snapshot.data.length.toString());
                  return SizedBox(
                    height: 270,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return listRecipe(
                              RecipeModel.fromJson(snapshot.data[index]));
                        }),
                  );
                } else {
                  return const Center(
                    child: Text("No Data Avaliable"),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  listRecipe(RecipeModel recipe) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipe: recipe),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 140,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    adjustImage(recipe.image.toString()) ?? URL_RECIPE,
                  ),
                ),
              ),
              height: 180,
            ),
            SizedBox(height: 5),
            Container(
              child: Text(
                adjustName(recipe.name),
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  mongoMethod() {
    switch (widget.mealType) {
      case "Breakfast":
        return MongoDatabase.getBreakfast();
      case "Lunch/Snacks":
        return MongoDatabase.getLunch();
      case "Dessert":
        return MongoDatabase.getDessert();
      case "High Rating":
        return MongoDatabase.getHighRating();
      case "< 15 Mins":
        return MongoDatabase.get15Min();
      default:
    }
  }

  adjustImage(String item) {
    const start = "https";
    const end = "jpg";

    final startIndex = item.indexOf(start);
    final endIndex = item.indexOf(end, startIndex + start.length);

    item = start + item.substring(startIndex + start.length, endIndex) + end;
    return item;
  }

  adjustName(String name) {
    if (name.length > 25) {
      return name.substring(0, 22) + "...";
    } else {
      return name;
    }
  }
}
