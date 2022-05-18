import 'dart:convert';

import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/components/dialogs/show_alert_dialog.dart';
import 'package:ne_yapsam_ki/components/useful_methods.dart';
import 'package:ne_yapsam_ki/pages/books/book_model.dart';

import 'package:http/http.dart' as http;

import '../../constants/globals.dart';
import '../../dbHelper/mongodb_user.dart';

class BookDetail extends StatefulWidget {
  String bookID;

  BookDetail({
    required this.bookID,
  });

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  late BookModel book;
  bool _isLoading = true;
  late bool isFavorite;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isFav();

    getBookDetail(widget.bookID);
  }

  getBookDetail(String? id) async {
    try {
      final response = await http
          .get(Uri.parse("https://www.googleapis.com/books/v1/volumes/$id"));

      BookModel book1;
      book1 = BookModel.fromApi(jsonDecode(response.body));

      book = book1;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("error get book detail $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Scaffold(
            appBar: AppBar(
              actions: [
                user!.isAnonymous
                    ? IconButton(
                        iconSize: 35,
                        onPressed: () {
                          showAlertDialog(
                            context,
                            content: "You have to sign in first!",
                            defaultActionText: "Sign In",
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).popAndPushNamed("/login");
                            },
                            cancelActionText: "Cancel",
                            onPressedCancel: Navigator.of(context).pop,
                          );
                        },
                        icon: Icon(FontAwesomeIcons.solidHeart),
                      )
                    : FavoriteButton(
                        isFavorite: isFavorite,
                        valueChanged: (_isFavorite) {
                          setState(() {
                            if (!_isFavorite) {
                              deleteFav();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Deleted from your favorites."),
                              ));
                            } else {
                              addFav();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Added to your favorites."),
                              ));
                            }
                          });
                        },
                      ),
              ],
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
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  child: Image.network(
                    book.thumbnail ?? URL_BOOK,
                    errorBuilder: (context, exception, stackTrace) {
                      return Image.network(
                        URL_BOOK,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  height: 200,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Text(
                      book.title ?? "null",
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
                        itemCount: book.authors?.length ?? 0,
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
                        itemCount: book.categories?.length ?? 0,
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
                    Column(
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            parseHtmlString(book.description!),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              ],
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
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }

  Future<void> addFav() async {
    await MongoDBInsert.updateBook(
      getUUID(),
      widget.bookID,
    );
  }

  Future<void> deleteFav() async {
    await MongoDBInsert.deleteBook(
      getUUID(),
      widget.bookID,
    );
  }

  Future<void> isFav() async {
    await MongoDBInsert.checkBook(
      getUUID(),
      widget.bookID,
    ).then((value) => setState(() => {
          isFavorite = value,
        }));
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }
}
