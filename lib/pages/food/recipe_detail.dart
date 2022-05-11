import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

class RecipeDetail extends StatelessWidget {
  final RecipeModel recipe;

  RecipeDetail({required this.recipe});
  @override
  Widget build(BuildContext context) {
    List ingredients = adjust(recipe.ingredients);
    List description = adjust(recipe.description);
    int count = 1;

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
      body: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      child: SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          adjustImage(recipe.image.toString()) ?? URL_RECIPE,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  recipe.name,
                  style: GoogleFonts.mcLaren(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Text(
                    adjustServings(recipe.servings).toString() + " Servings",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    FontAwesomeIcons.utensilSpoon,
                    color: Colors.white,
                  ),
                  Text(
                    (recipe.calories != 0
                            ? recipe.calories.toString()
                            : "Unknown") +
                        " Calories",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.utensils,
                    color: Colors.white,
                  ),
                  Text(
                    " Ingredients",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        Text(
                          ingredients[index],
                          style: GoogleFonts.mcLaren(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.edit,
                    color: Colors.white,
                  ),
                  Text(
                    " Recipe",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: description.length,
                itemBuilder: (context, index) {
                  return Text(
                    (index + 1).toString() + "- " + description[index],
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  adjust(String item) {
    List indexes = [];
    List ingredients = [];
    for (int index = 0; item[index] != ')'; index++) {
      if (item[index] == "\"") {
        indexes.add(index + 1);
      }
    }

    int i = 0;

    while (i < indexes.length - 1) {
      String word = item.substring(indexes[i], indexes[i + 1] - 1);
      ingredients.add(word);
      i = i + 2;
    }

    return ingredients;
  }

  adjustImage(String item) {
    const start = "https";
    const end = "jpg";

    final startIndex = item.indexOf(start);
    final endIndex = item.indexOf(end, startIndex + start.length);

    item = start + item.substring(startIndex + start.length, endIndex) + end;
    return item;
  }

  adjustServings(int servings) {
    if (servings == 0) {
      return "-";
    } else {
      return servings;
    }
  }
}
