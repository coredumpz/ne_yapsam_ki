import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

import '../../components/dialogs/show_alert_dialog.dart';
import '../../dbHelper/mongodb_user.dart';

class RecipeDetail extends StatefulWidget {
  final RecipeModel recipe;

  RecipeDetail({required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  late bool isFavorite;
  bool _isLoading = true;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isFav();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Scaffold(
            appBar: AppBar(
              actions: [
                user!.isAnonymous
                    ? IconButton(
                        iconSize: 35,
                        onPressed: () {
                          showAlertDialog(
                            context,
                            content: "You have to sign in first!",
                            defaultActionText: "Sign In",
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).popAndPushNamed("/login");
                            },
                            cancelActionText: "Cancel",
                            onPressedCancel: Navigator.of(context).pop,
                          );
                        },
                        icon: Icon(FontAwesomeIcons.solidHeart),
                      )
                    : FavoriteButton(
                        isFavorite: isFavorite,
                        valueChanged: (_isFavorite) {
                          setState(() {
                            if (!_isFavorite) {
                              deleteFav();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Deleted from your favorites."),
                              ));
                            } else {
                              addFav();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Added to your favorites."),
                              ));
                            }
                          });
                        },
                      ),
              ],
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
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
                              adjustImage(widget.recipe.image.toString()) ??
                                  URL_RECIPE,
                              fit: BoxFit.cover,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.network(
                                  URL_RECIPE,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      widget.recipe.name,
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
                        adjustServings(widget.recipe.servings).toString() +
                            " Servings",
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
                        (widget.recipe.calories != 0
                                ? widget.recipe.calories.toString()
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
                  buildTabBar(),
                ],
              ),
            ),
          );
  }

  adjust(String item) {
    List indexes = [];
    List ingredients = [];

    if (!item.contains(")")) {
      ingredients.add("Not Available");
    }
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
    if (startIndex <= 0 || endIndex <= 0) {
      return URL_RECIPE;
    }
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

  Future<void> addFav() async {
    await MongoDBInsert.updateRecipe(
      getUUID(),
      widget.recipe.name.toString(),
    );
  }

  Future<void> deleteFav() async {
    await MongoDBInsert.deleteRecipe(
      getUUID(),
      widget.recipe.name.toString(),
    );
  }

  Future<void> isFav() async {
    await MongoDBInsert.checkRecipe(
      getUUID(),
      widget.recipe.name.toString(),
    ).then((value) => setState(() => {
          isFavorite = value,
          _isLoading = false,
        }));
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          ButtonsTabBar(
            backgroundColor: Colors.red,
            unselectedBackgroundColor: Colors.grey[300],
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            labelStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                iconMargin: EdgeInsets.all(50),
                icon: Icon(FontAwesomeIcons.utensils),
                text: "Ingredients",
              ),
              Tab(
                iconMargin: EdgeInsets.all(50),
                icon: Icon(FontAwesomeIcons.edit),
                text: "Recipe",
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: <Widget>[
                ingredients(),
                recipe(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ingredients() {
    List ingredients = adjust(widget.recipe.ingredients);

    return ListView.builder(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  recipe() {
    List description = adjust(widget.recipe.description);

    return ListView.builder(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
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
    );
  }
}
