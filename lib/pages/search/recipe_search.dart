import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../dbHelper/mongodb.dart';
import '../../models/genre_model.dart';
import '../../models/movie/movie_model.dart';
import '../food/recipe_detail.dart';
import '../food/recipe_model.dart';
import '../movies_TMDB/description.dart';

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({Key? key}) : super(key: key);

  @override
  State<RecipeSearch> createState() => _GenrePageState();
}

class _GenrePageState extends State<RecipeSearch> {
  List recipes = [];
  String searchedWord = "";

  bool _isLoading = true;

  int tag = -2;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Center(
            child: AnimSearchBar(
              helpText: "Search for a recipe...",
              suffixIcon: const Icon(FontAwesomeIcons.search),
              width: 400,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  tag = -1;
                  searchedWord = textController.text;
                  print(searchedWord);
                  mongoMethod();
                });
              },
            ),
          ),
          ChipsChoice<int>.single(
            choiceStyle: const C2ChoiceStyle(color: Colors.red),
            value: tag,
            onChanged: (val) => setState(() {
              tag = val;
              _isLoading = false;
            }),
            choiceItems: C2Choice.listFrom<int, String>(
              source: recipeCategories,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          Container(
            height: 450,
            child: _isLoading
                ? Container()
                : Column(
                    children: [
                      Flexible(
                        child: FutureBuilder(
                          future: mongoMethod(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 8,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return listRecipe(RecipeModel.fromJson(
                                        snapshot.data[index]));
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text("No Data Avaliable"),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  mongoMethod() {
    switch (tag) {
      case -1:
        return MongoDatabase.getSearched(searchedWord);
      case 0:
        return MongoDatabase.getLowCal();
      case 1:
        return MongoDatabase.getHighRating();
      case 2:
        return MongoDatabase.getMostReviewed();
      case 3:
        return MongoDatabase.get1Serving();
      case 4:
        return MongoDatabase.get30Min();
      case 5:
        return MongoDatabase.get15Min();
      case 6:
        return MongoDatabase.getDessert();
      case 7:
        return MongoDatabase.getVegetable();
      case 8:
        return MongoDatabase.getBeverages();
      case 9:
        return MongoDatabase.getSauces();
      case 10:
        return MongoDatabase.getMeat();
      case 11:
        return MongoDatabase.getChicken();
      case 12:
        return MongoDatabase.getLunch();
      case 13:
        return MongoDatabase.getBread();
      case 14:
        return MongoDatabase.getHealthy();
      default:
    }
  }

  listRecipe(RecipeModel recipe) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetail(recipe: recipe),
            ),
          );
        },
        child: SizedBox(
          width: 140,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      adjustImage(recipe.image.toString()),
                    ),
                  ),
                ),
                height: 130,
              ),
              SizedBox(height: 5),
              Container(
                child: Text(
                  adjustName(recipe.name),
                  style: GoogleFonts.mcLaren(
                    textStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    adjustServings(recipe.servings).toString(),
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    FontAwesomeIcons.utensilSpoon,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    (recipe.calories != 0 ? recipe.calories.toString() : "-") +
                        " Cal",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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

  adjustName(String name) {
    if (name.length > 20) {
      return name.substring(0, 17) + "...";
    } else {
      return name;
    }
  }
}
