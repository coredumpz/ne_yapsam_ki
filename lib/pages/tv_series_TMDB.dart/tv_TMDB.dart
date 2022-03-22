import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/series_lists.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_genre_page.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../movies_TMDB/genre_model.dart';

class TvTMDB extends StatefulWidget {
  TvTMDB({Key? key}) : super(key: key);

  @override
  State<TvTMDB> createState() => _TvTMDBState();
}

class _TvTMDBState extends State<TvTMDB> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List popularSeries = [];
  List topratedSeries = [];
  List latestSeries = [];
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

    //Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map popularresult = await tmdbWithCustomLogs.v3.tv.getPopular();
    Map topratedresult = await tmdbWithCustomLogs.v3.tv.getTopRated();
    Map latestresult = await tmdbWithCustomLogs.v3.tv.getOnTheAir();
    Map tvgenreresult = await tmdbWithCustomLogs.v3.genres.getTvlist();
    tvGenres = Genre.genresFromSnapshot(tvgenreresult["genres"]);

    print(latestresult);

    setState(() {
      //trendingSeries = trendingresult["results"];
      popularSeries = popularresult["results"];
      topratedSeries = topratedresult["results"];
      latestSeries = latestresult["results"];
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
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemCount: tvGenres.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TvGenrePage(
                                    genreID: tvGenres[index].id,
                                    genreName: tvGenres[index].genre,
                                  ),
                                ),
                              );
                            },
                            child: Text(tvGenres[index].genre),
                          ),
                        );
                      }),
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
