import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/game/game_list_detail_model.dart';
import 'package:ne_yapsam_ki/pages/games/game_detail.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:http/http.dart' as http;

class MoreGames extends StatefulWidget {
  int platformID;
  String platformName;

  MoreGames({required this.platformID, required this.platformName});

  @override
  State<MoreGames> createState() => _GenrePageState();
}

class _GenrePageState extends State<MoreGames> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List<GameListDetail> gameList = [];

  bool _isLoading = true;
  int page = 1;

  bool positive = false;
  String region = "US";
  String language = "en-US";

  @override
  void initState() {
    super.initState();
    loadGames(page);
  }

  loadGames(int page) async {
    gameList.clear();

    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?platforms=${widget.platformID}&page=$page&page_size=30&key=5ac29048d12d45d0949c77038115cb56'));

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
          widget.platformName + " Games",
          style: GoogleFonts.mcLaren(
            textStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Flexible(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: gameList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameDetailPage(id: gameList[index].id!),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  gameList[index].image != null
                                      ? gameList[index].image!
                                      : URL_GAME,
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.network(
                                      URL_GAME,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  gameList[index].name ?? "null",
                                  style: GoogleFonts.mcLaren(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: NumberPaginator(
                      numberPages: 10,
                      onPageChange: (int index) {
                        setState(() {
                          print(index);
                          page = index + 1;
                          loadGames(page);
                        });
                      },
                      initialPage: 0,
                      height: 55,
                      buttonUnselectedForegroundColor: Colors.white,
                      buttonSelectedBackgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
