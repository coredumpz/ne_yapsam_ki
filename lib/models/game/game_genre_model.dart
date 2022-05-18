class GameGenre {
  int? id;
  String? name;
  String? image;

  GameGenre({
    this.id,
    this.name,
    this.image,
  });

  factory GameGenre.fromApi(Map<String, dynamic> data) {
    return GameGenre(
      id: data['id'],
      name: data['name'],
      image: data['image_background'],
    );
  }
}
