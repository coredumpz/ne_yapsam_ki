import 'package:flutter/material.dart';

import '../../models/movie_model.dart';
import 'movie_detail.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

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
                    movieName: movie.title,
                    description: movie.description,
                    imgURL: movie.imageUrl,
                    imdbRate: movie.imdb,
                    year: movie.year,
                    genre: movie.genre,
                  ),
                ),
              );
            },
            leading: Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(movie.imageUrl), fit: BoxFit.fill)),
            ),
            title: Text(movie.title),
            subtitle: Text(movie.genre),
            trailing: Column(
              children: [
                Text(movie.year),
                const SizedBox(
                  height: 15,
                ),
                Text("⭐ " + movie.imdb + "/10"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
