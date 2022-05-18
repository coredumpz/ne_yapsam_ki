import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/models/game/game_detail_model.dart';
import 'package:ne_yapsam_ki/pages/games/game_detail.dart';
import 'package:http/http.dart' as http;

import '../../dbHelper/mongodb_user.dart';

class FavoriteGames extends StatefulWidget {
  List gameList;

  FavoriteGames({Key? key, required this.gameList}) : super(key: key);

  @override
  State<FavoriteGames> createState() => _FavoriteGamesState();
}

class _FavoriteGamesState extends State<FavoriteGames> {
  List<GameDetail> gameList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  loadContent() async {
    for (var item in widget.gameList) {
      final response = await http.get(Uri.parse(
          'https://api.rawg.io/api/games/$item?key=5ac29048d12d45d0949c77038115cb56'));

      final items = jsonDecode(response.body);
      GameDetail tempGame = GameDetail.fromApi(items);
      gameList.add(tempGame);
    }

    setState(() {
      _isLoading = false;
    });
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
    return gameList.isEmpty
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
            itemCount: gameList.length,
            itemBuilder: (context, index) {
              final item = gameList[index];
              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      deleteFav(gameList[index].id!);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${gameList[index].name} is deleted."),
                        ),
                      );

                      setState(() {
                        gameList.removeAt(index);
                      });
                    },
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: ((context) => {
                            deleteFav(gameList[index].id!),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("${gameList[index].name} is deleted."),
                              ),
                            ),
                            setState(() {
                              gameList.removeAt(index);
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

  Widget buildListTile(GameDetail game) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailPage(
              id: game.id!,
            ),
          ),
        );
      },
      title: Text(
        game.name.toString(),
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
        backgroundImage: NetworkImage(game.image.toString()),
      ),
    );
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  deleteFav(int gameID) async {
    await MongoDBInsert.deleteGame(getUUID(), gameID);
  }
}
