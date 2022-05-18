import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/description.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../../models/movie/movie_model.dart';

class MovieSurveyResult extends StatefulWidget {
  String genre;
  String duration;
  String movieDate;

  MovieSurveyResult({
    Key? key,
    required this.duration,
    required this.genre,
    required this.movieDate,
  }) : super(key: key);

  @override
  _MovieSurveyResultState createState() => _MovieSurveyResultState();
}

class _MovieSurveyResultState extends State<MovieSurveyResult> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  List<Movie> movieList = [];
  bool _isLoading = true;
  int randomPage = 0;
  int randomMoviePage = 0;
  late Movie randomMovie;

  PageController? _pageController;
  int initialPage = 0;

  final _random = Random();

  @override
  void initState() {
    super.initState();
    loadContent();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: initialPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
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

    randomPage = _random.nextInt(10) + 1;
    randomMoviePage = _random.nextInt(19) + 1;

    String? movieDate;
    int? duration;
    Map? result;

    if (widget.movieDate == "LATEST") {
      movieDate = "2015-01-01";
      if (widget.duration == "LONG") {
        duration = 120;
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          releaseDateGreaterThan: movieDate,
          withRunTimeGreaterThan: duration,
        );
      } else if (widget.duration == "SHORT") {
        duration = 100;
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          releaseDateGreaterThan: movieDate,
          withRuntimeLessThan: duration,
        );
      } else {
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          releaseDateGreaterThan: movieDate,
        );
      }
    } else if (widget.movieDate == "OLD") {
      movieDate = "2000-01-01";
      if (widget.duration == "LONG") {
        duration = 120;
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          releaseDateLessThan: movieDate,
          withRunTimeGreaterThan: duration,
        );
      } else if (widget.duration == "SHORT") {
        duration = 100;
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          releaseDateLessThan: movieDate,
          withRuntimeLessThan: duration,
        );
      } else {
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          releaseDateLessThan: movieDate,
        );
      }
    } else if (widget.movieDate == "BOTH") {
      if (widget.duration == "LONG") {
        duration = 120;
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          withRunTimeGreaterThan: duration,
        );
      } else if (widget.duration == "SHORT") {
        duration = 100;
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
          withRuntimeLessThan: duration,
        );
      } else {
        result = await tmdbWithCustomLogs.v3.discover.getMovies(
          page: randomPage,
          withGenres: widget.genre,
        );
      }
    } else {
      result = await tmdbWithCustomLogs.v3.discover.getMovies(
        page: randomPage,
        withGenres: widget.genre,
      );
    }

    movieList = Movie.moviesFromSnapshot(result["results"]);
    movieList.shuffle();

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
          onPressed: () =>
              Navigator.of(context).popAndPushNamed("/surveyMovie"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white30,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white30, Colors.white.withOpacity(0.4)],
          ),
        ),
        child: buildResult(context),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AspectRatio(
                  aspectRatio: 0.85,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        movieCard(movieList[index]),
                  ),
                ),
              ],
            ),
          );
  }

  movieCard(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDescription(
              movie: movie,
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
                      movie.posterPath != null
                          ? TMDB_URL_BASE + movie.posterPath!
                          : URL_DEFAULT,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Text(
                movie.title.toString(),
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
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
