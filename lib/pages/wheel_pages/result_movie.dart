import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/description.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/movie/movie_model.dart';

class MovieResult extends StatefulWidget {
  const MovieResult({Key? key}) : super(key: key);

  @override
  _MovieResultState createState() => _MovieResultState();
}

class _MovieResultState extends State<MovieResult> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  List<Movie> topratedMovies = [];

  bool _isLoading = true;
  int randomPage = 0;
  int randomMoviePage = 0;
  late Movie randomMovie;

  final _random = Random();

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  // Random Movie
  loadContent() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    randomPage = _random.nextInt(20) + 1;
    randomMoviePage = _random.nextInt(19) + 1;

    Map topratedresult =
        await tmdbWithCustomLogs.v3.movies.getTopRated(page: randomPage);

    topratedMovies = Movie.moviesFromSnapshot(topratedresult["results"]);
    randomMovie = topratedMovies[randomMoviePage];

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
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white70,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.grey.withOpacity(0.2)],
          ),
        ),
        child: movieCard(),
      ),
    );
  }

  movieCard() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDescription(
                    movie: randomMovie,
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
                            randomMovie.posterPath != null
                                ? TMDB_URL_BASE + randomMovie.posterPath!
                                : URL_DEFAULT,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      randomMovie.title.toString(),
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
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
