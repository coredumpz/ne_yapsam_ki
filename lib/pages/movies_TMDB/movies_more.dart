import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/description.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/movie/movie_model.dart';

class MoreMovies extends StatefulWidget {
  String title;

  MoreMovies({required this.title});

  @override
  State<MoreMovies> createState() => _GenrePageState();
}

class _GenrePageState extends State<MoreMovies> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List<Movie> movieList = [];

  bool _isLoading = true;
  int page = 1;

  bool positive = false;
  String region = "US";
  String language = "en-US";

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

    if (widget.title == "Top Rated") {
      Map topratedmovieList = await tmdbWithCustomLogs.v3.movies.getTopRated(
        region: region,
        language: language,
        page: page,
      );
      movieList = Movie.moviesFromSnapshot(topratedmovieList["results"]);
    } else if (widget.title == "Up Coming") {
      Map upcomingmovieList = await tmdbWithCustomLogs.v3.movies.getUpcoming(
        region: region,
        language: language,
        page: page,
      );
      movieList = Movie.moviesFromSnapshot(upcomingmovieList["results"]);
    } else if (widget.title == "Now Playing") {
      Map nowplayingmovieList =
          await tmdbWithCustomLogs.v3.movies.getNowPlaying(
        region: region,
        language: language,
        page: page,
      );
      movieList = Movie.moviesFromSnapshot(nowplayingmovieList["results"]);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + "Movies",
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
                      itemCount: movieList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDescription(movie: movieList[index]),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  movieList[index].posterPath != null
                                      ? TMDB_URL_BASE +
                                          movieList[index].posterPath!
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
                          print(index);
                          page = index + 1;
                          loadmovies();
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
