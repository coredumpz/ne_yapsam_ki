import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/games/game_detail.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../models/game/game_list_detail_model.dart';

class GameSurveyResult extends StatefulWidget {
  String genre;
  String platform;
  String date;

  GameSurveyResult({
    Key? key,
    required this.platform,
    required this.genre,
    required this.date,
  }) : super(key: key);

  @override
  _GameSurveyResultState createState() => _GameSurveyResultState();
}

class _GameSurveyResultState extends State<GameSurveyResult> {
  List<GameListDetail> gameList = [];
  bool _isLoading = true;
  int randomPage = 0;
  int randomNum = 0;

  PageController? _pageController;
  int initialPage = 0;

  final _random = Random();

  @override
  void initState() {
    super.initState();
    loadContent();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: initialPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  loadContent() async {
    gameList.clear();

    int platformID = 4;
    randomPage = _random.nextInt(6) + 1;
    randomNum = _random.nextInt(19) + 1;

    int? date;

    if (widget.platform == "PC") {
      platformID = 4;
    } else if (widget.platform == "Playstation 5") {
      platformID = 187;
    } else if (widget.platform == "XBOX-ONE") {
      platformID = 1;
    } else if (widget.platform == "Playstation 4") {
      platformID = 18;
    } else {
      platformID = 21;
    }

    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?genres=${widget.genre}&platforms=$platformID&page=$randomPage&page_size=30&key=5ac29048d12d45d0949c77038115cb56'));

    final items = jsonDecode(response.body)['results'];

    List<GameListDetail> list = [];

    for (var item in items) {
      list.add(GameListDetail.fromApi(item));
    }

    list.shuffle();

    if (widget.date == "LATEST") {
      date = 2015;
      for (var item in list) {
        if (int.parse(item.released!.substring(0, 4)) > date &&
            gameList.length <= 5) {
          gameList.add(item);
        }
      }
    } else if (widget.date == "OLD") {
      date = 2010;
      for (var item in list) {
        if (int.parse(item.released!.substring(0, 4)) < date &&
            gameList.length <= 5) {
          gameList.add(item);
        }
      }
    } else {
      for (var item in list) {
        if (gameList.length <= 5) {
          gameList.add(item);
        }
      }
    }

    if (gameList.isEmpty) {
      loadContent();
    }
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
          onPressed: () => Navigator.of(context).popAndPushNamed("/surveyGame"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white30,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white30, Colors.white.withOpacity(0.4)],
          ),
        ),
        child: buildResult(context),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AspectRatio(
                  aspectRatio: 0.85,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: gameList.length,
                    itemBuilder: (context, index) => gameCard(gameList[index]),
                  ),
                ),
              ],
            ),
          );
  }

  gameCard(GameListDetail game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      game.image.toString(),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Text(
                game.name.toString(),
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
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
