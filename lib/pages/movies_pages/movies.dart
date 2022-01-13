import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_sort.dart';
import 'package:ne_yapsam_ki/utils/provider.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSortedButtonStatus()
          ? _buildSortedMovieList()
          : _buildMoviesList(),
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: const Text("Sort By"),
        onPressed: () {
          selectedGenres.clear();
          Provider.of<WheelProvider>(context, listen: false)
              .setSortButtonPressed = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CheckBoxListTileDemo(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoviesList() {
    return Container(
      child: movies.isNotEmpty
          ? ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return MovieCard(
                  movie: movies[index],
                );
              },
            )
          : const Center(child: Text('No Movies')),
    );
  }

  Widget _buildSortedMovieList() {
    for (int i = 0; i < movies.length; i++) {
      if (i == 0) {
        sortedMovies.clear();
      }

      for (int j = 0; j < selectedGenres.length; j++) {
        if (movies[i].genre.contains(selectedGenres.elementAt(j))) {
          sortedMovies.add(movies[i]);
          j = selectedGenres.length;
        }
      }
    }

    return Container(
      child: sortedMovies.isNotEmpty
          ? ListView.builder(
              itemCount: sortedMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return MovieCard(
                  movie: sortedMovies[index],
                );
              },
            )
          : const Center(child: Text('No Movies Found')),
    );
  }

  bool getSortedButtonStatus() {
    return Provider.of<WheelProvider>(context, listen: false)
        .isSortButtonPressed;
  }
}
