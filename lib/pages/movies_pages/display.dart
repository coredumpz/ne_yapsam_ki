import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_card.dart';
import 'package:ne_yapsam_ki/pages/movies_pages/movie_detail.dart';

class MongoDBDisplay extends StatefulWidget {
  MongoDBDisplay({Key? key}) : super(key: key);

  @override
  State<MongoDBDisplay> createState() => _MongoDBDisplayState();
}

class _MongoDBDisplayState extends State<MongoDBDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
      )),
    );
  }
}
