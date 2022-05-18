import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';
import 'package:ne_yapsam_ki/pages/books/book_genre_page.dart';
import 'package:ne_yapsam_ki/pages/books/book_model.dart';
import 'package:http/http.dart' as http;

class BooksList extends StatefulWidget {
  final String genre;

  BooksList({required this.genre});

  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  List<BookModel> books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGenre(widget.genre);
  }

  loadGenre(String genre) async {
    try {
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=subject:$genre&orderBy=newest"));

      final items = jsonDecode(response.body)['items'];
      List<BookModel> bookList = [];
      for (var item in items) {
        bookList.add(BookModel.fromApi(item));
      }

      books.addAll(bookList);

      // Before calling setState check if the state is mounted.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("error get books $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.genre + " Books",
                      style: GoogleFonts.mcLaren(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BooksGenrePage(genreName: widget.genre)),
                            );
                          },
                          child: Text(
                            "See More..",
                            style: GoogleFonts.mcLaren(
                              textStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (books[index].id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(
                                  bookID: books[index].id!,
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          width: 140,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      books[index].thumbnail ?? URL_DEFAULT,
                                    ),
                                  ),
                                ),
                                height: 200,
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                child: Text(
                                  adjustTitle(books[index].title.toString()) ??
                                      'NA',
                                  style: GoogleFonts.mcLaren(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  adjustTitle(String title) {
    if (title.length > 20) {
      return title.substring(0, 20);
    } else {
      return title;
    }
  }
}
