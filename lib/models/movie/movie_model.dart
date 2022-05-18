class Movie {
  final int id;
  final String? title;
  final String? backdropPath;
  final String? posterPath;
  final String? overview;
  final num? voteAverage;
  final String? releaseDate;
  final List? genreIDs;

  Movie({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIDs,
  });

  factory Movie.fromJson(dynamic json) {
    return Movie(
      id: json['id'] as int,
      title: json["title"],
      backdropPath: json["backdrop_path"],
      posterPath: json["poster_path"],
      overview: json["overview"],
      voteAverage: json["vote_average"],
      releaseDate: json["release_date"],
      genreIDs: json["genre_ids"],
    );
  }

  static List<Movie> moviesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Movie.fromJson(data);
    }).toList();
  }
}
