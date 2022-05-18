class MovieDetail {
  final int id;
  final String? title;
  final String? backdropPath;
  final String? posterPath;
  final String? overview;
  final num? voteAverage;
  final String? releaseDate;
  final int? runtime;
  final List? genreIDs;

  MovieDetail({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genreIDs,
  });

  factory MovieDetail.fromJson(dynamic json) {
    return MovieDetail(
      id: json['id'] as int,
      title: json["title"],
      backdropPath: json["backdrop_path"],
      posterPath: json["poster_path"],
      overview: json["overview"],
      voteAverage: json["vote_average"],
      releaseDate: json["release_date"],
      runtime: json["runtime"],
      genreIDs: json["genre_ids"],
    );
  }
}
