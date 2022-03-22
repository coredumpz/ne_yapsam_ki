import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/movies_list.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'genre_model.dart';
import 'genre_page.dart';

class HomeTMDB extends StatefulWidget {
  HomeTMDB({Key? key}) : super(key: key);

  @override
  State<HomeTMDB> createState() => _HomeTMDBState();
}

class _HomeTMDBState extends State<HomeTMDB> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List topratedMovies = [];
  List upcomingMovies = [];
  List nowplayingMovies = [];
  List movieList = [];
  List genreList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map topratedresult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map genreresults = await tmdbWithCustomLogs.v3.genres.getMovieList();
    genreList = Genre.genresFromSnapshot(genreresults["genres"]);

    Map upcomingresult = await tmdbWithCustomLogs.v3.movies.getUpcoming();
    Map nowplayingresult = await tmdbWithCustomLogs.v3.movies.getNowPlaying();

    setState(() {
      topratedMovies = topratedresult['results'];
      upcomingMovies = upcomingresult['results'];
      nowplayingMovies = nowplayingresult["results"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: ListView.builder(
      //       itemCount: genreList.length,
      //       itemBuilder: (context, index) {
      //         return SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: TextButton(
      //               onPressed: () {
      //                 print(genreList[index].id);
      //               },
      //               child: genreList[index].name),
      //         );
      //       }),
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemCount: genreList.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: TextButton(
                            onPressed: () {
                              print(genreList[index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenrePage(
                                    genreID: genreList[index].id,
                                    genreName: genreList[index].genre,
                                  ),
                                ),
                              );
                            },
                            child: Text(genreList[index].genre),
                          ),
                        );
                      }),
                ),
                // TV(tv: tv),
                // TrendingMovies(
                //   trending: trendingMovies,
                // ),
                MoviesList(
                  movies: topratedMovies,
                  title: "Top Rated",
                ),
                MoviesList(
                  movies: upcomingMovies,
                  title: "Up Coming",
                ),
                MoviesList(
                  movies: nowplayingMovies,
                  title: "Now Playing",
                ),
              ],
            ),
    );
  }
}
