import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/pages/search/tv_search.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/series_lists.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/genre_model.dart';
import '../../models/series/series_model.dart';

class TvTMDB extends StatefulWidget {
  TvTMDB({Key? key}) : super(key: key);

  @override
  State<TvTMDB> createState() => _TvTMDBState();
}

class _TvTMDBState extends State<TvTMDB> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List<Series> popularSeries = [];
  List<Series> topratedSeries = [];
  List<Series> latestSeries = [];
  int value = 0;
  bool positive = false;

  List tvGenres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSeries();
  }

  loadSeries() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map popularresult = await tmdbWithCustomLogs.v3.tv.getPopular();
    Map topratedresult = await tmdbWithCustomLogs.v3.tv.getTopRated();
    Map latestresult = await tmdbWithCustomLogs.v3.tv.getOnTheAir();
    Map tvgenreresult = await tmdbWithCustomLogs.v3.genres.getTvlist();
    tvGenres = Genre.genresFromSnapshot(tvgenreresult["genres"]);

    setState(() {
      popularSeries = Series.seriesFromSnapshot(popularresult["results"]);
      topratedSeries = Series.seriesFromSnapshot(topratedresult["results"]);
      latestSeries = Series.seriesFromSnapshot(latestresult["results"]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  child: IconButton(
                    iconSize: 18,
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TVSearch(),
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
                TvSeries(
                  series: popularSeries,
                  title: "Popular",
                ),
                TvSeries(
                  series: topratedSeries,
                  title: "Top Rated",
                ),
                TvSeries(
                  series: latestSeries,
                  title: "Latest",
                ),
              ],
            ),
    );
  }
}
