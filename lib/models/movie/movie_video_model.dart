class MovieVideo {
  final String? name;
  final String? key;
  final String? site;
  final String? type;
  final bool? official;

  MovieVideo({
    required this.name,
    required this.key,
    required this.site,
    required this.type,
    required this.official,
  });

  factory MovieVideo.fromJson(dynamic json) {
    return MovieVideo(
      name: json['name'],
      key: json["key"],
      site: json["site"],
      type: json["type"],
      official: json["official"],
    );
  }
}
