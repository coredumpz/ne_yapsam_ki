import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/books/book_detail.dart';
import 'package:ne_yapsam_ki/pages/books/book_model.dart';
import 'package:http/http.dart' as http;

import '../../dbHelper/mongodb_user.dart';

class FavoriteBooks extends StatefulWidget {
  List bookList;

  FavoriteBooks({Key? key, required this.bookList}) : super(key: key);

  @override
  State<FavoriteBooks> createState() => _FavoriteBooksState();
}

class _FavoriteBooksState extends State<FavoriteBooks> {
  List<BookModel> bookList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  loadContent() async {
    try {
      for (var item in widget.bookList) {
        final response = await http.get(
            Uri.parse("https://www.googleapis.com/books/v1/volumes/$item"));
        BookModel book;
        book = BookModel.fromApi(jsonDecode(response.body));
        bookList.add(book);
      }

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
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bodyContent(context),
    );
  }

  bodyContent(BuildContext context) {
    return bookList.isEmpty
        ? Center(
            child: Text(
              "You didnt add any favorites.",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              final item = bookList[index];
              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      deleteFav(bookList[index].id.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${bookList[index].title} is deleted."),
                        ),
                      );

                      setState(() {
                        bookList.removeAt(index);
                      });
                    },
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: ((context) => {
                            deleteFav(bookList[index].id.toString()),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${bookList[index].title} is deleted."),
                              ),
                            ),
                            setState(() {
                              bookList.removeAt(index);
                            }),
                          }),
                      icon: Icons.delete,
                      label: "Delete",
                    ),
                  ],
                ),
                child: buildListTile(item),
              );
            },
          );
  }

  Widget buildListTile(BookModel book) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetail(
              bookID: book.id.toString(),
            ),
          ),
        );
      },
      title: Text(
        book.title.toString(),
        style: GoogleFonts.mcLaren(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(book.thumbnail.toString()),
      ),
    );
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  deleteFav(String bookID) async {
    await MongoDBInsert.deleteBook(getUUID(), bookID);
  }
}
