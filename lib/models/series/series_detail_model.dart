class SeriesDetail {
  final int id;
  final String? title;
  final String? backdropPath;
  final String? posterPath;
  final String? overview;
  final num? voteAverage;
  final String? releaseDate;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final List? genreIDs;

  SeriesDetail({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.genreIDs,
  });

  factory SeriesDetail.fromJson(dynamic json) {
    return SeriesDetail(
      id: json['id'],
      title: json["original_name"],
      backdropPath: json["backdrop_path"],
      posterPath: json["poster_path"],
      overview: json["overview"],
      voteAverage: json["vote_average"],
      releaseDate: json["first_air_date"],
      numberOfSeasons: json["number_of_seasons"],
      numberOfEpisodes: json["number_of_episodes"],
      genreIDs: json["genre_ids"],
    );
  }
}
