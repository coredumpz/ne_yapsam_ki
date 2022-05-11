import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/movie/movie_detail_model.dart';
import 'package:ne_yapsam_ki/models/movie/movie_model.dart';
import 'package:ne_yapsam_ki/models/movie/movie_video_model.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/movies_list.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDescription extends StatefulWidget {
  final Movie movie;

  const MovieDescription({required this.movie});

  @override
  State<MovieDescription> createState() => _MovieDescriptionState();
}

class _MovieDescriptionState extends State<MovieDescription> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  bool _isLoading = true;

  List<Movie> recomList = [];
  late MovieDetail movieDetail;

  YoutubePlayerController? controller;
  MovieVideo? movieVideo;
  bool _isVideoAvailable = false;

  @override
  void deactivate() {
    controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  loadDetails() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    // load video
    Map videoDetail =
        await tmdbWithCustomLogs.v3.movies.getVideos(widget.movie.id);

    Map movieDetails =
        await tmdbWithCustomLogs.v3.movies.getDetails(widget.movie.id);

    movieDetail = MovieDetail.fromJson(movieDetails);
    print(movieDetail.runtime);

    for (var i = 0; i < videoDetail["results"].length; i++) {
      if (videoDetail["results"][i]["type"] == "Trailer") {
        movieVideo = MovieVideo.fromJson(videoDetail["results"][i]);
        _isVideoAvailable = true;
        break;
      }
    }

    if (_isVideoAvailable) {
      controller = YoutubePlayerController(
        initialVideoId: movieVideo!.key.toString(),
        flags: const YoutubePlayerFlags(
          mute: false, // sound on?
          loop: false, // repeat?
          autoPlay: false,
        ),
      );
    }

    // load movie recommendations
    Map recom = await tmdbWithCustomLogs.v3.movies.getSimilar(widget.movie.id);

    setState(() {
      recomList = Movie.moviesFromSnapshot(recom["results"]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () => Navigator.pop(context),
                iconSize: 30,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),
            backgroundColor: Colors.black,
            body: Container(
              child: ListView(children: [
                Container(
                  height: 250,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: _isVideoAvailable
                              ? YoutubePlayer(
                                  controller: controller!,
                                  showVideoProgressIndicator: true,
                                )
                              : Image.network(
                                  widget.movie.backdropPath != null
                                      ? TMDB_URL_BASE +
                                          widget.movie.backdropPath!
                                      : URL_DEFAULT,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      widget.movie.title ?? 'Not Available',
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  indent: 30,
                  endIndent: 30,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        ' ⭐  ' + movieDetail.voteAverage.toString(),
                        style: GoogleFonts.mcLaren(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: _buildIconText(
                        FontAwesomeIcons.calendarAlt,
                        Colors.white,
                        widget.movie.releaseDate! != null
                            ? widget.movie.releaseDate!
                            : "null",
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: _buildIconText(
                        FontAwesomeIcons.clock,
                        Colors.white,
                        movieDetail.runtime! != null
                            ? movieDetail.runtime!.toString() + " min"
                            : "null",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 200,
                      width: 100,
                      child: Image.network(
                        widget.movie.posterPath != null
                            ? TMDB_URL_BASE + widget.movie.posterPath!
                            : URL_DEFAULT,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.movie.overview ?? "Not Avaliable",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )),
                    ),
                  ],
                ),
                MoviesList(
                  movies: recomList,
                  title: "You may like these also... ",
                )
              ]),
            ),
          );
  }

  Widget _buildIconText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(color: Colors.white, fontSize: 15),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
