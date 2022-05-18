import 'dart:convert';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';

import '../books/book_model.dart';
import 'package:http/http.dart' as http;

class BookSearch extends StatefulWidget {
  const BookSearch({Key? key}) : super(key: key);

  @override
  State<BookSearch> createState() => _GenrePageState();
}

class _GenrePageState extends State<BookSearch> {
  List<BookModel> books = [];

  int page = 1;
  bool _isLoading = true;

  int tag = -1;
  TextEditingController textController = TextEditingController();

  loadGenre(String genre) async {
    try {
      books.clear();
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=subject:$genre&orderBy=newest&maxResults=40"));

      final items = jsonDecode(response.body)['items'];
      List<BookModel> bookList = [];
      for (var item in items) {
        bookList.add(BookModel.fromApi(item));
      }

      books.addAll(bookList);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("error get books $e");
    }
  }

  searchAuthor(String word) async {
    try {
      books.clear();
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=inauthor:$word&orderBy=newest&maxResults=10"));

      final items = jsonDecode(response.body)['items'];

      List<BookModel> bookList = [];
      for (var item in items) {
        bookList.add(BookModel.fromApi(item));
      }

      books.addAll(bookList);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("error get books $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Center(
            child: AnimSearchBar(
              helpText: "Search for a book...",
              suffixIcon: const Icon(FontAwesomeIcons.search),
              width: 400,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.text != ""
                      ? searchAuthor(textController.text)
                      : null;

                  textController.clear();
                });
              },
            ),
          ),
          ChipsChoice<int>.single(
            choiceStyle: const C2ChoiceStyle(color: Colors.red),
            value: tag,
            onChanged: (val) => setState(() {
              tag = val;
              setState(() {
                loadGenre(bookCategory[tag]);
              });
            }),
            choiceItems: C2Choice.listFrom<int, String>(
              source: bookCategory,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          _isLoading
              ? Container()
              : Column(
                  children: [
                    GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(
                                  bookID: books[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Image.network(
                              books[index].thumbnail ?? URL_BOOK,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.network(
                                  URL_BOOK,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            height: 200,
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
