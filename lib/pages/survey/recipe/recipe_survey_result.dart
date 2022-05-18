import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_detail.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/globals.dart';
import '../../../dbHelper/mongodb.dart';

class RecipeSurveyResult extends StatefulWidget {
  String recipeCategory;
  String calorie;
  String servings;

  RecipeSurveyResult({
    Key? key,
    required this.calorie,
    required this.recipeCategory,
    required this.servings,
  }) : super(key: key);

  @override
  _RecipeSurveyResultState createState() => _RecipeSurveyResultState();
}

class _RecipeSurveyResultState extends State<RecipeSurveyResult> {
  int randomPage = 0;
  int randomMoviePage = 0;
  List<RecipeModel> recipeList = [];

  String? recipeCategory;
  double? calorie;
  int? servings;

  PageController? _pageController;
  int initialPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: initialPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

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
          onPressed: () =>
              Navigator.of(context).popAndPushNamed("/surveyRecipe"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white30,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white30, Colors.white.withOpacity(0.4)],
          ),
        ),
        child: buildResult(context),
      ),
    );
  }

  getResultIndex() {
    return Provider.of<WheelProvider>(context).wheelIndex;
  }

  buildResult(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AspectRatio(
            aspectRatio: 0.85,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 3,
              itemBuilder: (context, index) => FutureBuilder(
                future: mongoMethod(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      recipeList.clear();

                      for (var item in snapshot.data) {
                        recipeList.add(RecipeModel.fromJson(item));
                      }
                      recipeList.shuffle();
                      recipeList = recipeDecisions(recipeList);

                      return recipeCard(recipeList[index]);
                    } else {
                      return const Center(
                        child: Text("No Data Avaliable"),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  recipeCard(RecipeModel recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      ).image),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Text(
                recipe.name,
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  mongoMethod() {
    switch (widget.recipeCategory) {
      case "High Rating":
        return MongoDatabase.getHighRating();
      case "Most Reviewed":
        return MongoDatabase.getMostReviewed();
      case "< 30 Mins":
        return MongoDatabase.get30Min();
      case "< 15 Mins":
        return MongoDatabase.get15Min();
      case "Dessert":
        return MongoDatabase.getDessert();
      case "Vegetable":
        return MongoDatabase.getVegetable();
      case "Beverages":
        return MongoDatabase.getBeverages();
      case "Sauces":
        return MongoDatabase.getSauces();
      case "Meat":
        return MongoDatabase.getMeat();
      case "Chicken":
        return MongoDatabase.getChicken();
      case "Lunch/Snacks":
        return MongoDatabase.getLunch();
      case "Breads":
        return MongoDatabase.getBread();
      case "Healthy":
        return MongoDatabase.getHealthy();
      default:
    }
  }

  recipeDecisions(List<RecipeModel> recipeList) {
    List<RecipeModel> resultList = [];

    if (widget.calorie == "HIGH") {
      calorie = 250.0;
      if (widget.servings == "MULTIPLE") {
        servings = 4;
        for (var item in recipeList) {
          if (item.calories > calorie! && item.servings >= servings!) {
            if (resultList.length <= 5 && resultList.contains(item) != true) {
              resultList.add(item);
            }
          }
        }
      } else if (widget.servings == "AVERAGE") {
        servings = 2;
        for (var item in recipeList) {
          if (item.calories > calorie! &&
              item.servings >= servings! &&
              item.servings <= 4) {
            if (resultList.length <= 5 && resultList.contains(item) != true) {
              resultList.add(item);
            }
          }
        }
      } else {
        servings = 2;
        for (var item in recipeList) {
          if (item.calories > calorie! && item.servings <= servings!) {
            if (resultList.length <= 5 && resultList.contains(item) != true) {
              resultList.add(item);
            }
          }
        }
      }
    } else if (widget.calorie == "LOW") {
      calorie = 200.0;
      if (widget.servings == "MULTIPLE") {
        servings = 4;
        for (var item in recipeList) {
          if (item.calories < calorie! && item.servings >= servings!) {
            if (resultList.length <= 5 && resultList.contains(item) != true) {
              resultList.add(item);
            }
          }
        }
      } else if (widget.servings == "AVERAGE") {
        servings = 2;
        for (var item in recipeList) {
          if (item.calories < calorie! &&
              item.servings >= servings! &&
              item.servings <= 4) {
            if (resultList.length <= 5 && resultList.contains(item) != true) {
              resultList.add(item);
            }
          }
        }
      } else {
        servings = 2;
        for (var item in recipeList) {
          if (item.calories < calorie! && item.servings <= servings!) {
            if (resultList.length <= 5 && resultList.contains(item) != true) {
              resultList.add(item);
            }
          }
        }
      }
    } else {
      for (var item in recipeList) {
        if (resultList.length <= 5 && resultList.contains(item) != true) {
          resultList.add(item);
        }
      }
    }

    return resultList;
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
