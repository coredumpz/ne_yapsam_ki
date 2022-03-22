import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'description.dart';

class GenrePage extends StatefulWidget {
  int genreID;
  String genreName;

  GenrePage({required this.genreID, required this.genreName});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List movies = [];

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
        await tmdbWithCustomLogs.v3.discover.getMovies(withGenres: "$genreID");

    setState(() {
      movies = movielistresult["results"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.genreName + " Movies",
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
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Description(
                            name: movies[index]['title'],
                            bannerurl: 'https://image.tmdb.org/t/p/w500' +
                                movies[index]['backdrop_path'],
                            posterurl: 'https://image.tmdb.org/t/p/w500' +
                                movies[index]['poster_path'],
                            description: movies[index]['overview'],
                            vote: movies[index]['vote_average'].toString(),
                            launch_on: movies[index]['release_date'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500' +
                                  movies[index]['poster_path']),
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
