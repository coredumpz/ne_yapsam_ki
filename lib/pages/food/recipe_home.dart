// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_category.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_lists.dart';
import 'package:ne_yapsam_ki/pages/search/recipe_search.dart';

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
          Container(
            child: IconButton(
              iconSize: 18,
              alignment: Alignment.centerLeft,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipeSearch(),
                  ),
                );
              },
              icon: const Icon(FontAwesomeIcons.search),
            ),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.black,
                width: 8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
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
