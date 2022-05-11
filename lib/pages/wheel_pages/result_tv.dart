import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/description.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/movie/movie_model.dart';
import '../../models/series/series_model.dart';

class TVResult extends StatefulWidget {
  const TVResult({Key? key}) : super(key: key);

  @override
  _TVResultState createState() => _TVResultState();
}

class _TVResultState extends State<TVResult> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  List<Series> topratedTV = [];
  bool _isLoading = true;
  int randomPage = 0;
  int randomMoviePage = 0;
  late Series randomSeries;

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

  // Random Tv
  loadContent() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    randomPage = _random.nextInt(20) + 1;
    randomMoviePage = _random.nextInt(9) + 1;

    Map topratedresult =
        await tmdbWithCustomLogs.v3.tv.getPopular(page: randomPage);

    topratedTV = Series.seriesFromSnapshot(topratedresult["results"]);
    randomSeries = topratedTV[randomMoviePage];

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
                  padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
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
                    randomSeries.posterPath != null
                        ? TMDB_URL_BASE + randomSeries.posterPath!
                        : URL_DEFAULT,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    child: Text(
                      randomSeries.title.toString(),
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
                          builder: (context) =>
                              TvDescription(series: randomSeries),
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
