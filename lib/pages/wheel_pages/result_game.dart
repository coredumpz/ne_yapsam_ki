import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/game/game_detail_model.dart';
import 'package:ne_yapsam_ki/pages/games/game_detail.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/description.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../models/game/game_list_detail_model.dart';
import '../../models/movie/movie_model.dart';
import '../../models/series/series_model.dart';

class GameResult extends StatefulWidget {
  const GameResult({Key? key}) : super(key: key);

  @override
  _GameResultState createState() => _GameResultState();
}

class _GameResultState extends State<GameResult> {
  bool _isLoading = true;
  int randomGenre = 0;
  int randomNum = 0;

  late GameListDetail game;

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
    randomGenre = _random.nextInt(19);
    randomNum = _random.nextInt(10);

    String genre = gameGenres[randomGenre];

    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?genres=$genre&key=5ac29048d12d45d0949c77038115cb56'));

    final items = jsonDecode(response.body)['results'];

    List<GameListDetail> list = [];

    for (var item in items) {
      list.add(GameListDetail.fromApi(item));
    }

    game = list[randomNum];

    setState(() {
      _isLoading = false;
    });
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
                    game.image.toString(),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
                  child: TextButton(
                    child: Text(
                      game.name.toString(),
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
                          builder: (context) => GameDetailPage(
                            id: game.id!,
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
