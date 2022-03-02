import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';

import '../../models/movie_model.dart';
import 'movie_detail.dart';

class MovieCard extends StatelessWidget {
  final MongoDbMovieModel movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsPage(
                    movie: movie,
                  ),
                ),
              );
            },
            leading: Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(movie.posterLink), fit: BoxFit.fill)),
            ),
            title: Text(movie.seriesTitle),
            subtitle: Text(movie.genre),
            trailing: Column(
              children: [
                Text(movie.releasedYear.toString()),
                const SizedBox(
                  height: 15,
                ),
                Text("⭐ " + movie.imdbRating.toString() + "/10"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
