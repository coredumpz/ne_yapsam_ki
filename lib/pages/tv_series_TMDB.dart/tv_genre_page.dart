import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/movie/movie_model.dart';
import 'package:ne_yapsam_ki/models/series/series_model.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TvGenrePage extends StatefulWidget {
  int genreID;
  String genreName;

  TvGenrePage({required this.genreID, required this.genreName});

  @override
  State<TvGenrePage> createState() => _TvGenrePageState();
}

class _TvGenrePageState extends State<TvGenrePage> {
  List<Series> tvSeries = [];

  final String apikey = '11c5704a37b7b08b3083df59a703204e';

  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    loadGenre(widget.genreID);
  }

  loadGenre(int genreID) async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map movielistresult =
        await tmdbWithCustomLogs.v3.discover.getTvShows(withGenres: "$genreID");

    setState(() {
      tvSeries = Series.seriesFromSnapshot(movielistresult["results"]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.genreName + " tvSeries",
          style: const TextStyle(color: Colors.white),
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
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                ),
                itemCount: tvSeries.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TvDescription(
                            series: tvSeries[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            tvSeries[index].posterPath != null
                                ? TMDB_URL_BASE + tvSeries[index].posterPath!
                                : "null",
                          ),
                        ),
                      ),
                      height: 200,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
