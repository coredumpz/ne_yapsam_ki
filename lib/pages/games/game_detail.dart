import 'dart:convert';

import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';

import 'package:http/http.dart' as http;

import '../../components/dialogs/show_alert_dialog.dart';
import '../../dbHelper/mongodb_user.dart';
import '../../models/game/game_detail_model.dart';

class GameDetailPage extends StatefulWidget {
  final int id;

  const GameDetailPage({required this.id});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late GameDetail game;
  bool _isLoading = true;

  late bool isFavorite;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isFav();
    gameCall(widget.id);
  }

  gameCall(int id) async {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games/$id?key=5ac29048d12d45d0949c77038115cb56'));

    final items = jsonDecode(response.body);

    GameDetail tempGame = GameDetail.fromApi(items);

    game = tempGame;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
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
            body: Container(
              child: ListView(children: [
                Container(
                  height: 250,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            game.image ?? URL_GAME,
                            errorBuilder: (context, exception, stackTrace) {
                              return Image.network(
                                URL_GAME,
                                fit: BoxFit.cover,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      game.name ?? 'Not Available',
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  indent: 30,
                  endIndent: 30,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        ' ⭐  ' + game.rating.toString(),
                        style: GoogleFonts.mcLaren(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: _buildIconText(FontAwesomeIcons.calendarAlt,
                          Colors.white, game.released ?? "-"),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: _buildIconText(
                        FontAwesomeIcons.clock,
                        Colors.white,
                        game.playtime.toString() + "h",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            removeHTML(game.description.toString()) ??
                                "Not Avaliable",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )),
                    ),
                  ],
                ),
              ]),
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
          width: 5,
        ),
        Text(
          text,
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(color: Colors.white, fontSize: 15),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  removeHTML(String desc) {
    final document = parse(desc);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Future<void> addFav() async {
    await MongoDBInsert.updateGame(
      getUUID(),
      widget.id,
    );
  }

  Future<void> deleteFav() async {
    await MongoDBInsert.deleteGame(
      getUUID(),
      widget.id,
    );
  }

  Future<void> isFav() async {
    await MongoDBInsert.checkGame(
      getUUID(),
      widget.id,
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
