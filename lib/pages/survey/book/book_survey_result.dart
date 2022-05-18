import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';

import '../../books/book_model.dart';
import 'package:http/http.dart' as http;

class BookSurveyResult extends StatefulWidget {
  String genre;
  String page;
  String date;

  BookSurveyResult({
    Key? key,
    required this.page,
    required this.genre,
    required this.date,
  }) : super(key: key);

  @override
  _BookSurveyResultState createState() => _BookSurveyResultState();
}

class _BookSurveyResultState extends State<BookSurveyResult> {
  List<BookModel> resultList = [];
  bool _isLoading = true;

  PageController? _pageController;
  int initialPage = 0;

  final _random = Random();

  @override
  void initState() {
    super.initState();
    loadContent();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: initialPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  // Random Movie
  loadContent() async {
    try {
      resultList.clear();
      int? date;
      int? page;

      int startIndex = _random.nextInt(100) + 1;
      print(startIndex);

      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=subject:${widget.genre}&maxResults=40"));

      final items = jsonDecode(response.body)['items'];
      List<BookModel> bookList = [];
      for (var item in items) {
        bookList.add(BookModel.fromApi(item));
      }

      if (bookList.isEmpty) {
        loadContent();
      }

      for (var item in bookList) {
        if (item.pageCount == null) {
          item.pageCount = 0;
        }
        if (item.publishedDate == null) {
          item.publishedDate = "2000";
        }
      }

      bookList.shuffle();

      if (widget.date == "LATEST") {
        date = 2015;
        if (widget.page == "LONG") {
          page = 400;
          for (var item in bookList) {
            if (int.parse(item.publishedDate!.substring(0, 4)) >= date &&
                item.pageCount! >= page) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        } else if (widget.page == "SHORT") {
          page = 250;
          for (var item in bookList) {
            if (int.parse(item.publishedDate!.substring(0, 4)) >= date &&
                item.pageCount! <= page) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        } else {
          for (var item in bookList) {
            if (int.parse(item.publishedDate!.substring(0, 4)) >= date) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        }
      } else if (widget.date == "OLD") {
        date = 2000;
        if (widget.page == "LONG") {
          page = 400;
          for (var item in bookList) {
            if (int.parse(item.publishedDate!.substring(0, 4)) <= date &&
                item.pageCount! >= page) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        } else if (widget.page == "SHORT") {
          page = 250;
          for (var item in bookList) {
            if (int.parse(item.publishedDate!.substring(0, 4)) <= date &&
                item.pageCount! <= page) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        } else {
          for (var item in bookList) {
            if (int.parse(item.publishedDate!.substring(0, 4)) >= date) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        }
      } else if (widget.page == "BOTH") {
        if (widget.page == "LONG") {
          page = 400;
          for (var item in bookList) {
            if (item.pageCount! >= page) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        } else if (widget.page == "SHORT") {
          page = 250;
          for (var item in bookList) {
            if (item.pageCount! <= page) {
              if (resultList.length != 5) {
                resultList.add(item);
              }
            }
          }
        } else {
          for (var item in bookList) {
            if (resultList.length != 5) {
              resultList.add(item);
            }
          }
        }
      } else {
        for (var item in bookList) {
          if (resultList.length != 5) {
            resultList.add(item);
          }
        }
      }

      if (resultList.isEmpty) {
        loadContent();
      }

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
          onPressed: () => Navigator.of(context).popAndPushNamed("/surveyBook"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white30,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white30, Colors.white.withOpacity(0.4)],
          ),
        ),
        child: buildResult(context),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AspectRatio(
                  aspectRatio: 0.85,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: resultList.length,
                    itemBuilder: (context, index) =>
                        movieCard(resultList[index]),
                  ),
                ),
              ],
            ),
          );
  }

  movieCard(BookModel book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      book.thumbnail!,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Text(
                  book.title.toString(),
                  style: GoogleFonts.mcLaren(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
