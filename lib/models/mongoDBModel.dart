// To parse this JSON data, do
//
//     final mongoDbMovieModel = mongoDbMovieModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbMovieModel mongoDbMovieModelFromJson(String str) =>
    MongoDbMovieModel.fromJson(json.decode(str));

String mongoDbMovieModelToJson(MongoDbMovieModel data) =>
    json.encode(data.toJson());

class MongoDbMovieModel {
  MongoDbMovieModel({
    required this.id,
    required this.posterLink,
    required this.seriesTitle,
    required this.releasedYear,
    required this.runtime,
    required this.genre,
    required this.imdbRating,
    required this.overview,
    required this.metaScore,
    required this.director,
    required this.noOfVotes,
    required this.gross,
  });

  ObjectId id;
  String posterLink;
  String seriesTitle;
  int releasedYear;
  int runtime;
  String genre;
  double imdbRating;
  String overview;
  int metaScore;
  String director;
  int noOfVotes;
  int gross;

  factory MongoDbMovieModel.fromJson(Map<String, dynamic> json) =>
      MongoDbMovieModel(
        id: json["_id"],
        posterLink: json["Poster_Link"],
        seriesTitle: json["Series_Title"],
        releasedYear: json["Released_Year"],
        runtime: json["Runtime"],
        genre: json["Genre"],
        imdbRating: json["IMDB_Rating"],
        overview: json["Overview"],
        metaScore: json["Meta_score"],
        director: json["Director"],
        noOfVotes: json["No_of_Votes"],
        gross: json["Gross"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Poster_Link": posterLink,
        "Series_Title": seriesTitle,
        "Released_Year": releasedYear,
        "Runtime": runtime,
        "Genre": genre,
        "IMDB_Rating": imdbRating,
        "Overview": overview,
        "Meta_score": metaScore,
        "Director": director,
        "No_of_Votes": noOfVotes,
        "Gross": gross,
      };
}
