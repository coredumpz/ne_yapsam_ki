import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/books/books_list.dart';
import 'package:ne_yapsam_ki/pages/search/book_search.dart';

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
      body: Column(
        children: [
          Container(
            child: IconButton(
              iconSize: 18,
              alignment: Alignment.centerLeft,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookSearch(),
                  ),
                );
              },
              icon: const Icon(FontAwesomeIcons.search),
            ),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.black,
                width: 8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bookCategory.length,
              itemBuilder: (BuildContext context, int index) {
                return BooksList(genre: bookCategory[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
