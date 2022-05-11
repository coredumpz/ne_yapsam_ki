import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
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

  List<String> imgList = [
    "movie",
    "tvseries",
    "book",
    "game",
    "food",
  ];

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

      print(items);

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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.blue.withOpacity(0.2)],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/${imgList[getResultIndex()]}.png",
                scale: 4,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "YOUR ${imgList[getResultIndex()].toUpperCase()} IS :",
                    style: GoogleFonts.mcLaren(
                      textStyle: const TextStyle(
                          color: Color.fromARGB(255, 13, 135, 17),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            buildResult(context),
          ],
        ),
      ),
    );
  }

  getResultIndex() {
    return Provider.of<WheelProvider>(context).wheelIndex;
  }

  buildResult(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    book.thumbnail.toString(),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 20, right: 30, left: 30),
                    child: TextButton(
                      child: Text(
                        book.title.toString(),
                        style: GoogleFonts.mcLaren(
                          textStyle: const TextStyle(
                              color: Color.fromARGB(255, 13, 135, 17),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              bookID: book.id!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
