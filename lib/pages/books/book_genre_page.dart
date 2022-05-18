import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';

import 'book_model.dart';

class BooksGenrePage extends StatefulWidget {
  String genreName;

  BooksGenrePage({required this.genreName});

  @override
  State<BooksGenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<BooksGenrePage> {
  List<BookModel> books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGenre(widget.genreName);
  }

  loadGenre(String genre) async {
    try {
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=subject:$genre&orderBy=newest&maxResults=40"));

      final items = jsonDecode(response.body)['items'];
      List<BookModel> bookList = [];
      for (var item in items) {
        bookList.add(BookModel.fromApi(item));
      }

      books.addAll(bookList);
      print(books.length);

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
          widget.genreName.toUpperCase() + " BOOKS",
          style: GoogleFonts.mcLaren(
            textStyle: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            bookID: books[index].id!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            books[index].thumbnail!,
                          ),
                        ),
                      ),
                      height: 200,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
