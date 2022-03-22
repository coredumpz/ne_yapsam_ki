// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_category.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_lists.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_model.dart';

class RecipeHome extends StatefulWidget {
  RecipeHome({Key? key}) : super(key: key);

  @override
  State<RecipeHome> createState() => _RecipeHomeState();
}

class _RecipeHomeState extends State<RecipeHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: dishTypes.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeCategory(
                              dishType: dishTypes[index],
                            ),
                          ),
                        );
                      },
                      child: Text(dishTypes[index]),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: mealTypes.length,
              itemBuilder: (context, index) {
                return RecipeList(mealType: mealTypes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
