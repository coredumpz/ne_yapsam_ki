import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_detail.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

import '../../constants/globals.dart';
import '../../dbHelper/mongodb.dart';

class RecipeCategory extends StatefulWidget {
  String dishType;

  RecipeCategory({
    required this.dishType,
  });

  @override
  State<RecipeCategory> createState() => _RecipeCategoryState();
}

class _RecipeCategoryState extends State<RecipeCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.dishType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: mongoMethod(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                print(widget.dishType + "= " + snapshot.data.length.toString());
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return listRecipe(
                        RecipeModel.fromJson(snapshot.data[index]));
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
        width: 140,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    adjustImage(recipe.image.toString()),
                  ),
                ),
              ),
              height: 150,
            ),
            SizedBox(height: 5),
            Container(
              child: Text(
                recipe.name,
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  mongoMethod() {
    switch (widget.dishType) {
      case "Dessert":
        return MongoDatabase.getDessert();
      case "Vegetable":
        return MongoDatabase.getVegetable();
      case "Beverages":
        return MongoDatabase.getBeverages();
      case "Sauces":
        return MongoDatabase.getSauces();
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
}
