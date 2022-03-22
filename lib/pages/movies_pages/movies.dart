import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_sort.dart';
import 'package:ne_yapsam_ki/utils/data_provider.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';
import '../../models/movie_model.dart';
import 'movie_card.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviesPageState();
  }
}

class _MoviesPageState extends State<MoviesPage> {
  late int movieLenght;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildMoviesList(),
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
    return SafeArea(
      child: FutureBuilder(
        future: sortedData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              var totalData = snapshot.data.length; // total length of the data
              print("Total Data: " + totalData.toString());
              movieLenght = totalData;
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: MovieCard(
                        movie: MongoDbMovieModel.fromJson(snapshot.data[index]),
                      ),
                    );
                  });
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

  Widget _buildSortedMovieList() {
    return SafeArea(
      child: FutureBuilder(
        future: sortedData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: MovieCard(
                        movie: MongoDbMovieModel.fromJson(snapshot.data[index]),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("No Data Available."),
              );
            }
          }
        },
      ),
    );

    /*return Container(
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
    );*/
  }

  _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Provider.of<DataProvider>(context, listen: false).setDataSortIndex =
              0;
          setState(() {});
        },
        icon: const Icon(FontAwesomeIcons.backspace),
        color: Colors.red,
      ),
      title: PreferredSize(
        preferredSize: const Size.fromHeight(5.0),
        child: SizedBox(
          height: 30,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              OutlinedButton(
                onPressed: () {
                  Provider.of<DataProvider>(context, listen: false)
                      .setDataSortIndex = 1;
                  setState(() {});
                },
                child: const Text("IMDB > 7"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Provider.of<DataProvider>(context, listen: false)
                      .setDataSortIndex = 2;
                  setState(() {});
                },
                child: const Text("IMDB > 8"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Provider.of<DataProvider>(context, listen: false)
                      .setDataSortIndex = 3;
                  setState(() {});
                },
                child: const Text("IMDB > 9"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Provider.of<DataProvider>(context, listen: false)
                      .setDataSortIndex = 4;
                  setState(() {});
                },
                child: const Text("Latest Movies"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Provider.of<DataProvider>(context, listen: false)
                      .setDataSortIndex = 5;
                  setState(() {});
                },
                child: const Text("Must-See Movies"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sortedData() {
    switch (getDataSortIndex()) {
      case 0:
        return MongoDatabase.getData();
      case 1:
        return MongoDatabase.getIMDB_8();
      case 2:
        return MongoDatabase.getIMDB_8();
      case 3:
        return MongoDatabase.getIMDB_9();
      case 4:
        return MongoDatabase.getLatest();
      case 5:
        return MongoDatabase.getMustSee();
      default:
    }
  }

  bool getSortedButtonStatus() {
    return Provider.of<WheelProvider>(context, listen: false)
        .isSortButtonPressed;
  }

  int getDataSortIndex() {
    return Provider.of<DataProvider>(context, listen: false).dataSortIndex;
  }
}
