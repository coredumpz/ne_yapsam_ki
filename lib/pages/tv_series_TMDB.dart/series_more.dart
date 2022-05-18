import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../models/series/series_model.dart';

class MoreSeries extends StatefulWidget {
  String title;

  MoreSeries({required this.title});

  @override
  State<MoreSeries> createState() => _GenrePageState();
}

class _GenrePageState extends State<MoreSeries> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';
  List<Series> seriesList = [];

  bool _isLoading = true;
  int page = 1;

  bool positive = false;

  String language = "en-US";

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

    if (widget.title == "Top Rated") {
      Map topratedseriesList = await tmdbWithCustomLogs.v3.tv.getTopRated(
        language: language,
        page: page,
      );
      seriesList = Series.seriesFromSnapshot(topratedseriesList["results"]);
    } else if (widget.title == "Latest") {
      Map upcomingseriesList = await tmdbWithCustomLogs.v3.tv.getOnTheAir(
        language: language,
        page: page,
      );
      seriesList = Series.seriesFromSnapshot(upcomingseriesList["results"]);
    } else if (widget.title == "Popular") {
      Map nowplayingseriesList = await tmdbWithCustomLogs.v3.tv.getPopular(
        language: language,
        page: page,
      );
      seriesList = Series.seriesFromSnapshot(nowplayingseriesList["results"]);
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
                      itemCount: seriesList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TvDescription(series: seriesList[index]),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  seriesList[index].posterPath != null
                                      ? TMDB_URL_BASE +
                                          seriesList[index].posterPath!
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
                          loadSeries();
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
