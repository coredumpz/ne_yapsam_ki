class Series {
  final int id;
  final String? title;
  final String? backdropPath;
  final String? posterPath;
  final String? overview;
  final num? voteAverage;
  final String? releaseDate;
  final List? genreIDs;

  Series({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIDs,
  });

  factory Series.fromJson(dynamic json) {
    return Series(
      id: json['id'],
      title: json["original_name"],
      backdropPath: json["backdrop_path"],
      posterPath: json["poster_path"],
      overview: json["overview"],
      voteAverage: json["vote_average"],
      releaseDate: json["release_date"],
      genreIDs: json["genre_ids"],
    );
  }

  static List<Series> seriesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Series.fromJson(data);
    }).toList();
  }
}
