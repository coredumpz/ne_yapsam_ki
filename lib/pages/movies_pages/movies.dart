import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_sort.dart';
import 'movie_card.dart';
import 'movie_list.dart';
import '../../models/movie_model.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviesPageState();
  }
}

class _MoviesPageState extends State<MoviesPage> {
  final List<Movie> movies = MovieList.getMovies();

  Widget _buildMoviesList() {
    return Container(
      child: movies.length > 0
          ? ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return MovieCard(
                  movie: movies[index],
                );
              },
            )
          : const Center(child: Text('No Items')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMoviesList(),
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: const Text("Sort By"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CheckBoxListTileDemo(),
            ),
          );
        },
      ),
    );
  }
}
