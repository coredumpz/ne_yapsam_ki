import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/books/book_genre_page.dart';
import 'package:ne_yapsam_ki/pages/books/books_list.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/movies_list.dart';

import 'book_model.dart';
import 'package:http/http.dart' as http;

class BooksHome extends StatefulWidget {
  BooksHome({Key? key}) : super(key: key);

  @override
  State<BooksHome> createState() => _BooksHomeState();
}

class _BooksHomeState extends State<BooksHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: bookCategory.length,
        itemBuilder: (BuildContext context, int index) {
          return BooksList(genre: bookCategory[index]);
        },
      ),
    );
  }
}
