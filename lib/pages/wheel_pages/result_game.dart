import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/games/game_detail.dart';
import 'package:http/http.dart' as http;

import '../../models/game/game_list_detail_model.dart';

class GameResult extends StatefulWidget {
  const GameResult({Key? key}) : super(key: key);

  @override
  _GameResultState createState() => _GameResultState();
}

class _GameResultState extends State<GameResult> {
  bool _isLoading = true;

  late GameListDetail game;

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  loadContent() async {
    final _random = Random();
    int randomGenre = 0;
    int randomNum = 0;
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

    if (randomNum > list.length) {
      loadContent();
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
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white70,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.grey.withOpacity(0.2)],
          ),
        ),
        child: gameCard(),
      ),
    );
  }

  gameCard() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(
                    id: game.id!,
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
                            game.image != null ? game.image! : URL_DEFAULT,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      game.name.toString(),
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
