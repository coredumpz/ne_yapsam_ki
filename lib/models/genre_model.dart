class Genre {
  final int id;
  final String genre;

  Genre({required this.id, required this.genre});

  factory Genre.fromJson(dynamic json) {
    return Genre(
      id: json['id'] as int,
      genre: json["name"] as String,
    );
  }

  static List<Genre> genresFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Genre.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Genre {name: $id, genre: $genre}';
  }
}
