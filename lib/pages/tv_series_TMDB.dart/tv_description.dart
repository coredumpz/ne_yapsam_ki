import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb_user.dart';
import 'package:ne_yapsam_ki/models/series/series_detail_model.dart';
import 'package:ne_yapsam_ki/models/series/series_model.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/series_lists.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../components/dialogs/show_alert_dialog.dart';
import '../../models/movie/movie_video_model.dart';

class TvDescription extends StatefulWidget {
  Series series;

  TvDescription({
    required this.series,
  });

  @override
  State<TvDescription> createState() => _TvDescriptionState();
}

class _TvDescriptionState extends State<TvDescription> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  SeriesDetail? seriesDetail;
  List<Series> recomList = [];
  bool _isLoading = true;
  bool _isVideoAvailable = false;
  late bool isFavorite;

  final user = FirebaseAuth.instance.currentUser;

  YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=OeeqiCTOZjc&list=RDOeeqiCTOZjc&start_radio=1&ab_channel=Tu%C4%9Fkan")!);

  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isFav();
    loadVideo();
  }

  loadVideo() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map videoDetail =
        await tmdbWithCustomLogs.v3.tvSeasons.getVideos(widget.series.id, 1);

    Map seriesDetails =
        await tmdbWithCustomLogs.v3.tv.getDetails(widget.series.id);

    seriesDetail = SeriesDetail.fromJson(seriesDetails);

    Map recom = await tmdbWithCustomLogs.v3.tv.getSimilar(widget.series.id);
    MovieVideo? movieVideo;

    for (var i = 0; i < videoDetail["results"].length; i++) {
      if (videoDetail["results"][i]["type"] == "Trailer" ||
          videoDetail["results"][i]["type"] == "Teaser") {
        movieVideo = MovieVideo.fromJson(videoDetail["results"][i]);
        _isVideoAvailable = true;
        setController(movieVideo);
        break;
      }
    }

    setState(() {
      recomList = Series.seriesFromSnapshot(recom["results"]);
      _isLoading = false;
    });
  }

  setController(MovieVideo movieVideo) {
    var url = "https://www.youtube.com/watch?v=${movieVideo.key}";

    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        mute: false, // sound on?
        loop: false, // repeat?
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : YoutubePlayerBuilder(
            player: YoutubePlayer(controller: controller),
            builder: (context, player) => Scaffold(
              appBar: AppBar(
                actions: [
                  user!.isAnonymous
                      ? IconButton(
                          iconSize: 35,
                          onPressed: () {
                            showAlertDialog(
                              context,
                              content: "You have to sign in first!",
                              defaultActionText: "Sign In",
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).popAndPushNamed("/login");
                              },
                              cancelActionText: "Cancel",
                              onPressedCancel: Navigator.of(context).pop,
                            );
                          },
                          icon: Icon(FontAwesomeIcons.solidHeart),
                        )
                      : FavoriteButton(
                          isFavorite: isFavorite,
                          valueChanged: (_isFavorite) {
                            setState(() {
                              if (!_isFavorite) {
                                deleteFav();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Deleted from your favorites."),
                                ));
                              } else {
                                addFav();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Added to your favorites."),
                                ));
                              }
                            });
                          },
                        ),
                ],
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
              body: ListView(children: [
                Container(
                  height: 250,
                  child: SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: _isVideoAvailable
                        ? player
                        : Image.network(
                            widget.series.backdropPath != null
                                ? TMDB_URL_BASE + widget.series.backdropPath!
                                : URL_DEFAULT,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      seriesDetail!.title ?? 'Not Available',
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
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.series.voteAverage != null
                            ? '⭐ ' + widget.series.voteAverage.toString()
                            : "null",
                        style: GoogleFonts.mcLaren(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildIconText(
                      FontAwesomeIcons.calendarAlt,
                      Colors.white,
                      seriesDetail!.releaseDate != null
                          ? seriesDetail!.releaseDate.toString()
                          : "null",
                    ),
                    const Spacer(),
                    _buildIconText(
                      Icons.movie_creation,
                      Colors.white,
                      seriesDetail!.numberOfSeasons != null
                          ? seriesDetail!.numberOfSeasons.toString() +
                              " Seasons"
                          : "null",
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildIconText(
                        Icons.screen_lock_landscape,
                        Colors.white,
                        seriesDetail!.numberOfEpisodes != null
                            ? seriesDetail!.numberOfEpisodes.toString() +
                                " Episodes"
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
                        widget.series.posterPath != null
                            ? TMDB_URL_BASE + widget.series.posterPath!
                            : URL_DEFAULT,
                      ),
                    ),
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.series.overview ?? "null",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )),
                    ),
                  ],
                ),
                TvSeries(
                  series: recomList,
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
            textStyle: const TextStyle(color: Colors.white, fontSize: 14),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Future<void> addFav() async {
    await MongoDBInsert.updateSeries(getUUID(), widget.series.id);
  }

  Future<void> deleteFav() async {
    await MongoDBInsert.deleteSeries(getUUID(), widget.series.id);
  }

  Future<void> isFav() async {
    await MongoDBInsert.checkSeries(getUUID(), widget.series.id)
        .then((value) => setState(() => {
              isFavorite = value,
            }));
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }
}
