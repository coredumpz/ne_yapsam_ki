import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'book_model.dart';

class BookDescription extends StatefulWidget {
  String bookID;

  BookDescription({
    required this.bookID,
  });

  @override
  State<BookDescription> createState() => _BookDescriptionState();
}

class _BookDescriptionState extends State<BookDescription> {
  late BookModel book;
  bool _isLoading = true;

  getBookDetail(String? id) async {
    try {
      final response = await http
          .get(Uri.parse("https://www.googleapis.com/books/v1/volumes/$id"));

      //print("url ${response.request?.url}");
      print("response.body ${jsonDecode(response.body)}");
      BookModel book1;
      book1 = BookModel.fromApi(jsonDecode(response.body));

      setState(() {
        book = book1;
        _isLoading = false;
      });
    } catch (e) {
      print("error get book detail $e");
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getBookDetail(widget.bookID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(children: [
                Container(
                    height: 250,
                    child: Stack(children: [
                      Positioned(
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            book.thumbnail!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Text(
                          book.subtitle!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ])),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    book.title!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    book.bookUrl!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            book.description!,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                )
              ]),
            ),
    );
  }
}
