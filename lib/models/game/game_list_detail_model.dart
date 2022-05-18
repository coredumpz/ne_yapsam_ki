class GameListDetail {
  int? id;
  String? name;
  String? image;
  double? rating;
  int? metacritic;
  String? released;

  GameListDetail({
    this.id,
    this.name,
    this.image,
    this.rating,
    this.metacritic,
    this.released,
  });

  factory GameListDetail.fromApi(Map<String, dynamic> data) {
    return GameListDetail(
      id: data['id'],
      name: data['name'],
      image: data['background_image'],
      rating: data['rating'],
      metacritic: data['metacritic'],
      released: data['released'],
    );
  }
}
