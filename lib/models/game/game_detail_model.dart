class GameDetail {
  int? id;
  String? name;
  String? image;
  double? rating;
  int? metacritic;
  String? description;
  String? released;
  int? playtime;

  GameDetail({
    this.id,
    this.name,
    this.image,
    this.rating,
    this.metacritic,
    this.description,
    this.released,
    this.playtime,
  });

  factory GameDetail.fromApi(Map<String, dynamic> data) {
    return GameDetail(
      id: data['id'],
      name: data['name'],
      image: data['background_image'],
      rating: data['rating'],
      metacritic: data['metacritic'],
      description: data['description'],
      released: data['released'],
      playtime: data['playtime'],
    );
  }
}
