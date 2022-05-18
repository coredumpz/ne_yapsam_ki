import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_detail.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

import '../../dbHelper/mongodb_user.dart';

class FavoriteRecipes extends StatefulWidget {
  List recipeList;

  FavoriteRecipes({Key? key, required this.recipeList}) : super(key: key);

  @override
  State<FavoriteRecipes> createState() => _FavoriteRecipesState();
}

class _FavoriteRecipesState extends State<FavoriteRecipes> {
  List<RecipeModel> recipeList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  loadContent() async {
    for (var item in widget.recipeList) {
      final result = await MongoDatabase.getRecipe(item);

      recipeList.add(RecipeModel.fromJson(result[0]));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bodyContent(context),
    );
  }

  bodyContent(BuildContext context) {
    return recipeList.isEmpty
        ? Center(
            child: Text(
              "You didnt add any favorites.",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            itemCount: recipeList.length,
            itemBuilder: (context, index) {
              final item = recipeList[index];
              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      deleteFav(recipeList[index].name.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${recipeList[index].name} is deleted."),
                        ),
                      );

                      setState(() {
                        recipeList.removeAt(index);
                      });
                    },
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: ((context) => {
                            deleteFav(recipeList[index].name.toString()),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${recipeList[index].name} is deleted."),
                              ),
                            ),
                            setState(() {
                              recipeList.removeAt(index);
                            }),
                          }),
                      icon: Icons.delete,
                      label: "Delete",
                    ),
                  ],
                ),
                child: buildListTile(item),
              );
            },
          );
  }

  Widget buildListTile(RecipeModel recipe) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              recipe: recipe,
            ),
          ),
        );
      },
      title: Text(
        recipe.name.toString(),
        style: GoogleFonts.mcLaren(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: Image.network(
          adjustImage(recipe.image.toString()) ?? URL_RECIPE,
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stackTrace) {
            return Image.network(
              URL_RECIPE,
              fit: BoxFit.cover,
            );
          },
        ).image,
      ),
    );
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  deleteFav(String recipeName) async {
    await MongoDBInsert.deleteRecipe(getUUID(), recipeName);
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
}
