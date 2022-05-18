import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/series/series_model.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../dbHelper/mongodb_user.dart';
import '../../models/series/series_model.dart';

class FavoriteSeries extends StatefulWidget {
  List seriesList;

  FavoriteSeries({Key? key, required this.seriesList}) : super(key: key);

  @override
  State<FavoriteSeries> createState() => _FavoriteSeriesState();
}

class _FavoriteSeriesState extends State<FavoriteSeries> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  List<Series> seriesList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  loadContent() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    for (var item in widget.seriesList) {
      Map result = await tmdbWithCustomLogs.v3.tv.getDetails(item);

      seriesList.add(Series.fromJson(result));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bodyContent(context),
    );
  }

  bodyContent(BuildContext context) {
    return seriesList.isEmpty
        ? Center(
            child: Text(
              "You didnt add any favorites.",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.builder(
            itemCount: seriesList.length,
            itemBuilder: (context, index) {
              final item = seriesList[index];
              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      deleteFav(seriesList[index].id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${seriesList[index].title} is deleted."),
                        ),
                      );

                      setState(() {
                        seriesList.removeAt(index);
                      });
                    },
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: ((context) => {
                            deleteFav(seriesList[index].id),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${seriesList[index].title} is deleted."),
                              ),
                            ),
                            setState(() {
                              seriesList.removeAt(index);
                            }),
                          }),
                      icon: Icons.delete,
                      label: "Delete",
                    ),
                  ],
                ),
                child: buildListTile(item),
              );
            },
          );
  }

  Widget buildListTile(Series series) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TvDescription(
              series: series,
            ),
          ),
        );
      },
      title: Text(
        series.title.toString(),
        style: GoogleFonts.mcLaren(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: CircleAvatar(
        radius: 40,
        backgroundImage:
            NetworkImage(TMDB_URL_BASE + series.backdropPath.toString()),
      ),
    );
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  deleteFav(int seriesID) async {
    await MongoDBInsert.deleteSeries(getUUID(), seriesID);
  }
}
