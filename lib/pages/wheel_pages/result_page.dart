import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_detail.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';

class WheelResultPage extends StatefulWidget {
  const WheelResultPage({Key? key}) : super(key: key);

  @override
  _WheelResultPageState createState() => _WheelResultPageState();
}

class _WheelResultPageState extends State<WheelResultPage> {
  List<String> imgList = [
    "movie",
    "tvseries",
    "book",
    "song",
    "game",
    "food",
  ];

  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).popAndPushNamed("/wheel"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.blue.withOpacity(0.2)],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/${imgList[getResultIndex()]}.png",
                scale: 3,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "YOUR ${imgList[getResultIndex()].toUpperCase()} IS :",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            buildResult(context),
          ],
        ),
      ),
    );
  }

  getResultIndex() {
    return Provider.of<WheelProvider>(context).wheelIndex;
  }

  buildResult(BuildContext context) {
    /*return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            randomMovie.imageUrl,
            fit: BoxFit.fitHeight,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: TextButton(
              child: Text(
                randomMovie.title,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsPage(
                      movieName: randomMovie.title,
                      description: randomMovie.description,
                      imgURL: randomMovie.imageUrl,
                      imdbRate: randomMovie.imdb,
                      year: randomMovie.year,
                      genre: randomMovie.genre,
                    ),
                  ),
                );
              */
              }),
        ),
      ],
    );*/
    return SafeArea(
      child: FutureBuilder(
        future: MongoDatabase.getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              var totalData = snapshot.data.length; // total length of the data
              print("Total Data: " + totalData.toString());
              //var randomMovie = movies[_random.nextInt(movies.length)];
              var randomMovie = MongoDbMovieModel.fromJson(
                  snapshot.data[_random.nextInt(snapshot.data.length)]);
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      randomMovie.posterLink,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                        child: Text(
                          randomMovie.seriesTitle,
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(
                                movie: randomMovie,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("No Data Available."),
              );
            }
          }
        },
      ),
    );
  }
}
