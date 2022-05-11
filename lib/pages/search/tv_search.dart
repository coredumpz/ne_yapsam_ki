import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/series/series_model.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/genre_model.dart';
import '../../models/movie/movie_model.dart';
import '../movies_TMDB/description.dart';

class TVSearch extends StatefulWidget {
  const TVSearch({Key? key}) : super(key: key);

  @override
  State<TVSearch> createState() => _GenrePageState();
}

class _GenrePageState extends State<TVSearch> {
  List<Series> series = [];
  List<Genre> genreList = [];
  int page = 1;
  int choice = 0;
  String searchedTvSeries = "";

  final String apikey = '11c5704a37b7b08b3083df59a703204e';

  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  bool _isLoading = true;

  int tag = -1;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadGenre();
  }

  // load genres and take them in a list
  loadGenre() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map genreresults = await tmdbWithCustomLogs.v3.genres.getTvlist();
    print(genreresults);

    setState(() {
      genreList = Genre.genresFromSnapshot(genreresults["genres"]);
    });
  }

  loadGenreList(int genreID) async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map tvListResults = await tmdbWithCustomLogs.v3.discover.getTvShows(
      withGenres: "$genreID",
      page: page,
    );

    setState(() {
      series = [];
      series = Series.seriesFromSnapshot(tvListResults["results"]);
      _isLoading = false;
    });
  }

  searchTV(String tvName) async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map tvResult = await tmdbWithCustomLogs.v3.search.queryTvShows(
      tvName,
      page: page,
    );

    setState(() {
      series = [];
      series = Series.seriesFromSnapshot(tvResult["results"]);
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
          Center(
            child: AnimSearchBar(
              helpText: "Search for a movie...",
              suffixIcon: const Icon(FontAwesomeIcons.search),
              width: 400,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  choice = 2;
                  page = 1;
                  textController.text != ""
                      ? searchTV(textController.text)
                      : null;
                  searchedTvSeries = textController.text;
                  textController.clear();
                });
              },
            ),
          ),
          ChipsChoice<int>.single(
            choiceStyle: const C2ChoiceStyle(color: Colors.red),
            value: tag,
            onChanged: (val) => setState(() {
              choice = 1;
              page = 1;
              tag = val;
              loadGenreList(genreList[tag].id);
            }),
            choiceItems: C2Choice.listFrom<int, String>(
              source: tvGenreTypes,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          Container(
            height: 450,
            child: _isLoading
                ? Container()
                : Column(
                    children: [
                      Flexible(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: series.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TvDescription(
                                      series: series[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      series[index].posterPath != null
                                          ? TMDB_URL_BASE +
                                              series[index].posterPath!
                                          : URL_DEFAULT,
                                    ),
                                  ),
                                ),
                                height: 200,
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
                              page = index + 1;
                              choice == 1
                                  ? loadGenreList(genreList[tag].id)
                                  : searchTV(searchedTvSeries);
                            });
                          },
                          initialPage: 0,
                          height: 55,
                          buttonUnselectedForegroundColor: Colors.black,
                          buttonSelectedBackgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
