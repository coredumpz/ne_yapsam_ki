import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/survey_lists.dart';
import 'recipe_survey_result.dart';

class RecipeSurvey extends StatefulWidget {
  RecipeSurvey({Key? key}) : super(key: key);

  @override
  State<RecipeSurvey> createState() => _RecipeSurveyState();
}

class _RecipeSurveyState extends State<RecipeSurvey> {
  String? recipeCategory = "High Rating";
  String? calorie;
  String? servings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFA),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: buildContent(),
    );
  }

  buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pick a Category : ",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: recipeCategory,
              items: recipeCat.map(buildMenuItem).toList(),
              onChanged: (value) => setState(() => this.recipeCategory = value),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Calorie?",
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomRadioButton(
                elevation: 0,
                absoluteZeroSpacing: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: const [
                  'High',
                  'Low',
                  'Both',
                ],
                buttonValues: const [
                  "HIGH",
                  "LOW",
                  "BOTH",
                ],
                buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 18)),
                radioButtonValue: (value) {
                  calorie = value.toString();
                  print(value);
                },
                selectedColor: Theme.of(context).accentColor,
                width: 100,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Servings?",
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomRadioButton(
                width: 140,
                elevation: 0,
                absoluteZeroSpacing: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: const [
                  'Multiple (>4)',
                  'Average (2-4)',
                  "Couple (1-2)",
                ],
                buttonValues: const [
                  "MULTIPLE",
                  "AVERAGE",
                  "COUPLE",
                ],
                buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 16)),
                radioButtonValue: (value) {
                  servings = value.toString();
                },
                selectedColor: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
        ElevatedButton(
          child: const Text(
            "FIND",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeSurveyResult(
                  calorie: calorie.toString(),
                  recipeCategory: recipeCategory.toString(),
                  servings: servings.toString(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      );
}
