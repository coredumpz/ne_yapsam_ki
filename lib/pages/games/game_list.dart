import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:http/http.dart' as http;
import 'package:ne_yapsam_ki/pages/games/game_detail.dart';
import 'package:ne_yapsam_ki/pages/games/games_more.dart';

import '../../models/game/game_list_detail_model.dart';

class GameList extends StatefulWidget {
  final int id;
  final String title;

  GameList({required this.title, required this.id});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  List<GameListDetail> gameList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    gameCall(widget.id);
  }

  gameCall(int platform) async {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?platforms=$platform&key=5ac29048d12d45d0949c77038115cb56'));

    final items = jsonDecode(response.body)['results'];

    List<GameListDetail> list = [];

    for (var item in items) {
      list.add(GameListDetail.fromApi(item));
    }

    gameList.addAll(list);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.mcLaren(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoreGames(
                                        platformID: widget.id,
                                        platformName: widget.title,
                                      )),
                            );
                          },
                          child: Text(
                            "See More..",
                            style: GoogleFonts.mcLaren(
                              textStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: gameList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetailPage(
                                id: gameList[index].id!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 140,
                          child: Column(
                            children: [
                              Container(
                                child: Image.network(
                                  gameList[index].image ?? URL_GAME,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.network(
                                      URL_GAME,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                height: 200,
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  gameList[index].name ?? 'NA',
                                  style: GoogleFonts.mcLaren(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
