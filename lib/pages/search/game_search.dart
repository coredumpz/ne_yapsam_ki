import 'dart:convert';

import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import '../../models/game/game_list_detail_model.dart';
import 'package:http/http.dart' as http;

import '../games/game_detail.dart';

class GameSearch extends StatefulWidget {
  const GameSearch({Key? key}) : super(key: key);

  @override
  State<GameSearch> createState() => _GenrePageState();
}

class _GenrePageState extends State<GameSearch> {
  List<GameListDetail> gameList = [];

  int page = 1;
  bool _isLoading = true;

  int tag = -1;
  TextEditingController textController = TextEditingController();

  loadGenre(String genre) async {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?genres=$genre&page_size=50&key=5ac29048d12d45d0949c77038115cb56'));

    final items = jsonDecode(response.body)['results'];

    List<GameListDetail> list = [];

    for (var item in items) {
      list.add(GameListDetail.fromApi(item));
    }

    gameList.addAll(list);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ChipsChoice<int>.single(
            choiceStyle: const C2ChoiceStyle(color: Colors.red),
            value: tag,
            onChanged: (val) => setState(() {
              tag = val;
              setState(() {
                gameList.clear();
                loadGenre(gameGenres[tag]);
              });
            }),
            choiceItems: C2Choice.listFrom<int, String>(
              source: gameGenres,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          _isLoading
              ? Container()
              : Column(
                  children: [
                    GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: gameList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: InkWell(
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
                            child: SizedBox(
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.network(
                                      gameList[index].image ?? URL_DEFAULT,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, exception, stackTrace) {
                                        return Image.network(
                                          URL_GAME,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                    height: 130,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    child: Text(
                                      adjustName(gameList[index]
                                              .name
                                              .toString()) ??
                                          "NA",
                                      style: GoogleFonts.mcLaren(
                                        textStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.rate_review,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        gameList[index].metacritic.toString() ==
                                                "null"
                                            ? "-"
                                            : gameList[index]
                                                .metacritic
                                                .toString(),
                                        style: GoogleFonts.mcLaren(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        gameList[index].rating.toString(),
                                        style: GoogleFonts.mcLaren(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  adjustName(String name) {
    if (name.length > 20) {
      return name.substring(0, 17) + "...";
    } else {
      return name;
    }
  }
}
