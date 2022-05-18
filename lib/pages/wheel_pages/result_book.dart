import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';
import 'package:http/http.dart' as http;

import '../books/book_model.dart';

class BookResult extends StatefulWidget {
  const BookResult({Key? key}) : super(key: key);

  @override
  _BookResultState createState() => _BookResultState();
}

class _BookResultState extends State<BookResult> {
  bool _isLoading = true;
  int randomCategory = 0;
  int randomNum = 0;

  late BookModel book;

  final _random = Random();

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  loadContent() async {
    randomCategory = _random.nextInt(10);
    randomNum = _random.nextInt(40);

    String category = bookCategory[randomCategory];

    try {
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=subject:$category&orderBy=newest&maxResults=40"));

      final items = jsonDecode(response.body)['items'];
      List<BookModel> bookList = [];
      for (var item in items) {
        bookList.add(BookModel.fromApi(item));
      }

      book = bookList[randomNum];

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
        actions: [
          IconButton(
            color: Colors.black,
            alignment: Alignment.topRight,
            iconSize: 40.0,
            onPressed: () => setState(() {
              _isLoading = true;
              loadContent();
            }),
            icon: const Icon(Icons.refresh),
          ),
        ],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white70,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.grey.withOpacity(0.2)],
          ),
        ),
        child: bookCard(),
      ),
    );
  }

  bookCard() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetail(
                    bookID: book.id.toString(),
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
                          image: NetworkImage(
                            book.thumbnail != null
                                ? book.thumbnail!
                                : URL_DEFAULT,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      book.title.toString(),
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
