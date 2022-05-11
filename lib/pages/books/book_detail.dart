import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/components/useful_methods.dart';
import 'package:ne_yapsam_ki/pages/books/book_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  String bookID;

  DetailPage({
    required this.bookID,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late BookModel book;
  bool _isLoading = true;

  getBookDetail(String? id) async {
    try {
      final response = await http
          .get(Uri.parse("https://www.googleapis.com/books/v1/volumes/$id"));

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
          ? Container()
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 250,
                  child: Image.network(
                    book.thumbnail!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Text(
                      book.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        height: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: book.authors!.length,
                        itemBuilder: (context, index) {
                          return Text(
                            book.authors![index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mcLaren(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIconText(
                            FontAwesomeIcons.book,
                            Colors.orange[300]!,
                            " " + book.pageCount!.toString() + " pages"),
                        const SizedBox(
                          width: 10,
                        ),
                        _buildIconText(
                          FontAwesomeIcons.calendarAlt,
                          Colors.white,
                          book.publishedDate!,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: book.categories!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Chip(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              label: Text(
                                book.categories![index],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        parseHtmlString(book.description!),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            Icons.add,
                            Colors.grey[800]!,
                            'Add To Library',
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          _buildButton(
                            Icons.menu_book,
                            const Color(0xFF6741FF),
                            'Preview',
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }

  Widget _buildButton(IconData icon, Color color, String text) {
    return SizedBox(
      height: 40,
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }
}
