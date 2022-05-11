import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/pages/games/game_list.dart';
import 'package:ne_yapsam_ki/pages/search/game_search.dart';

import '../../constants/globals.dart';

class HomeGame extends StatefulWidget {
  HomeGame({Key? key}) : super(key: key);

  @override
  State<HomeGame> createState() => _HomeGameState();
}

class _HomeGameState extends State<HomeGame> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            child: IconButton(
              iconSize: 18,
              alignment: Alignment.centerLeft,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameSearch(),
                  ),
                );
              },
              icon: const Icon(FontAwesomeIcons.search),
            ),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.black,
                width: 8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            height: 500,
            child: ListView.builder(
                itemCount: gamePlatformIDS.length,
                itemBuilder: (BuildContext context, int index) {
                  return GameList(
                    id: gamePlatformIDS[index],
                    title: gamePlatformNames[index],
                  );
                }),
          )
        ],
      ),
    );
  }
}
