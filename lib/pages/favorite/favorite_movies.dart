import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../../dbHelper/mongodb_user.dart';
import '../../models/movie/movie_model.dart';
import '../movies_TMDB/description.dart';

class FavoriteMovies extends StatefulWidget {
  List movieList;

  FavoriteMovies({Key? key, required this.movieList}) : super(key: key);

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  final String apikey = '11c5704a37b7b08b3083df59a703204e';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMWM1NzA0YTM3YjdiMDhiMzA4M2RmNTlhNzAzMjA0ZSIsInN1YiI6IjYyMjRhM2M3NjgwYmU4MDA2ZGNhYTQ2NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.J782z7K-CcVx6sVjev285CnNL9caoKLiU5-doChf6Ik.C_Bkz_T8OybTGo3HfYsESNjN46LBYdw3LHdF-1TzYYs';

  List<Movie> movieList = [];
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

    for (var item in widget.movieList) {
      Map result = await tmdbWithCustomLogs.v3.movies.getDetails(item);

      movieList.add(Movie.fromJson(result));
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
    return movieList.isEmpty
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
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              final item = movieList[index];
              return Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      deleteFav(movieList[index].id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${movieList[index].title} is deleted."),
                        ),
                      );

                      setState(() {
                        movieList.removeAt(index);
                      });
                    },
                  ),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      onPressed: ((context) => {
                            deleteFav(movieList[index].id),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${movieList[index].title} is deleted."),
                              ),
                            ),
                            setState(() {
                              movieList.removeAt(index);
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

  Widget buildListTile(Movie movie) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDescription(
              movie: movie,
            ),
          ),
        );
      },
      title: Text(
        movie.title.toString(),
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
            NetworkImage(TMDB_URL_BASE + movie.backdropPath.toString()),
      ),
    );
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  deleteFav(int movieID) async {
    await MongoDBInsert.deleteMovies(getUUID(), movieID);
  }
}
