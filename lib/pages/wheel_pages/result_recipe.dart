import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_detail.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/description.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../dbHelper/mongodb.dart';
import '../../models/movie/movie_model.dart';
import '../../models/series/series_model.dart';

class RecipeResult extends StatefulWidget {
  const RecipeResult({Key? key}) : super(key: key);

  @override
  _RecipeResultState createState() => _RecipeResultState();
}

class _RecipeResultState extends State<RecipeResult> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  late RecipeModel recipe;
  int randomCategory = 0;
  int randomNum = 0;
  late Movie randomMovie;

  List<String> imgList = [
    "movie",
    "tvseries",
    "book",
    "game",
    "food",
  ];

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.blue.withOpacity(0.2)],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/${imgList[getResultIndex()]}.png",
                scale: 4,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "YOUR ${imgList[getResultIndex()].toUpperCase()} IS :",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                          color: Color.fromARGB(255, 13, 135, 17),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            buildResult(context),
          ],
        ),
      ),
    );
  }

  getResultIndex() {
    return Provider.of<WheelProvider>(context).wheelIndex;
  }

  buildResult(BuildContext context) {
    final _random = Random();
    int randomCategory = _random.nextInt(16);
    int randomNum = _random.nextInt(25);

    return FutureBuilder(
      future: MongoDatabase.getRandom(randomCategory),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            recipe = RecipeModel.fromJson(snapshot.data[randomNum]);

            return SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      adjustImage(recipe.image.toString()),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 20, right: 30, left: 30),
                    child: TextButton(
                      child: Text(
                        recipe.name.toString(),
                        style: GoogleFonts.mcLaren(
                          textStyle: const TextStyle(
                              color: Color.fromARGB(255, 13, 135, 17),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetail(
                              recipe: recipe,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("No Data Avaliable"),
            );
          }
        }
      },
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
}
