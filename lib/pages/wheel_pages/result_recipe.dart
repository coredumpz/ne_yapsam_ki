import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_detail.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

import '../../dbHelper/mongodb.dart';

class RecipeResult extends StatefulWidget {
  const RecipeResult({Key? key}) : super(key: key);

  @override
  _RecipeResultState createState() => _RecipeResultState();
}

class _RecipeResultState extends State<RecipeResult> {
  late RecipeModel recipe;
  int randomCategory = 0;
  int randomNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.black,
            alignment: Alignment.topRight,
            iconSize: 40.0,
            onPressed: () => setState(() {
              buildResult(context);
            }),
            icon: const Icon(Icons.refresh),
          ),
        ],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white70,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.grey.withOpacity(0.2)],
          ),
        ),
        child: buildResult(context),
      ),
    );
  }

  buildResult(BuildContext context) {
    final _random = Random();
    int randomCategory = _random.nextInt(16);
    int randomNum = _random.nextInt(99);

    return FutureBuilder(
      future: MongoDatabase.getRandom(randomCategory),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            if (randomNum > snapshot.data.length || randomNum == 0) {
              return buildResult(context);
            }

            recipe = RecipeModel.fromJson(snapshot.data[randomNum]);

            return recipeCard();
          } else {
            return const Center(
              child: Text("No Data Avaliable"),
            );
          }
        }
      },
    );
  }

  recipeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              recipe: recipe,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.network(
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
                ),
              ),
            ),
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                adjustName(recipe.name),
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  adjustName(String name) {
    if (name.length > 25) {
      return name.substring(0, 22) + "...";
    } else {
      return name;
    }
  }
}
