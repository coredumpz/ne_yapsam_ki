import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

class RecipeDetail extends StatelessWidget {
  final RecipeModel recipe;

  RecipeDetail({required this.recipe});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(children: [
          Container(
              height: 250,
              child: Stack(children: [
                Positioned(
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      recipe.image ?? URL_RECIPE,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(
                    "Time: " + recipe.totalTime.toString() + " minutes",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ])),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              recipe.label ?? "Not Available",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Calorie: " +
                  (recipe.calories != 0
                      ? recipe.calories.toString()
                      : "Unknown"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
              height: 300,
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: recipe.ingredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                          recipe.ingredients[index],
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
