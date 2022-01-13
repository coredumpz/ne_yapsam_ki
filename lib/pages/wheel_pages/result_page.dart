import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/models/movie_model.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_detail.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_list.dart';
import 'package:ne_yapsam_ki/utils/provider.dart';
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

  final List<Movie> movies = MovieList.getMovies();
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
    var randomMovie = movies[_random.nextInt(movies.length)];
    return Column(
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
              }),
        ),
      ],
    );

    /*switch (getResultIndex()) {
      case 0:
        var randomMovie = movies[_random.nextInt(movies.length)];
        return Column(
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
                  }),
            ),
          ],
        );
      case 1:
        return Container(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            child: const Text("tvseries"),
          ),
        );
      case 2:
        return Container(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            child: const Text("book"),
          ),
        );
      case 3:
        return Container(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            child: const Text("song"),
          ),
        );
      case 4:
        return Container(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            child: const Text("games"),
          ),
        );
      case 5:
        return Container(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            child: const Text("food"),
          ),
        );
      default:
    }*/
  }
}
