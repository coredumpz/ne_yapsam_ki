import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/models/movie/movie_model.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/movies_list.dart';
import 'package:ne_yapsam_ki/pages/search/movie_search.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/genre_model.dart';

class HomeTMDB extends StatefulWidget {
  HomeTMDB({Key? key}) : super(key: key);

  @override
  State<HomeTMDB> createState() => _HomeTMDBState();
}

class _HomeTMDBState extends State<HomeTMDB> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List<Movie> topratedMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> nowplayingMovies = [];
  List genreList = [];
  bool _isLoading = true;
  int value = 0;
  bool positive = false;

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
    Map upcomingresult = await tmdbWithCustomLogs.v3.movies.getUpcoming();
    Map nowplayingresult = await tmdbWithCustomLogs.v3.movies.getNowPlaying();

    Map genreresults = await tmdbWithCustomLogs.v3.genres.getMovieList();
    genreList = Genre.genresFromSnapshot(genreresults["genres"]);

    setState(() {
      topratedMovies = Movie.moviesFromSnapshot(topratedresult["results"]);
      topratedMovies = Movie.moviesFromSnapshot(topratedresult['results']);
      upcomingMovies = Movie.moviesFromSnapshot(upcomingresult['results']);
      nowplayingMovies = Movie.moviesFromSnapshot(nowplayingresult["results"]);
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
                          builder: (context) => const SearchPage(),
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
