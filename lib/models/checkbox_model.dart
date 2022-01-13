class CheckBoxListTileModel {
  int id;
  String img;
  String title;
  bool isCheck;

  CheckBoxListTileModel(
      {required this.id,
      required this.img,
      required this.title,
      required this.isCheck});

  static List<CheckBoxListTileModel> getGenres() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          id: 1,
          img:
              'https://static8.depositphotos.com/1005979/1008/i/950/depositphotos_10087766-stock-photo-action-word-on-red-round.jpg',
          title: "Action",
          isCheck: false),
      CheckBoxListTileModel(
          id: 2,
          img:
              'https://img.redbull.com/images/c_crop,w_5600,h_2800,x_0,y_805,f_auto,q_auto/c_scale,w_1200/redbullcom/2018/07/06/ed2aaaf0-43f4-4e11-b555-9c139d6e0c23/adventure-racing-collection',
          title: "Adventure",
          isCheck: false),
      CheckBoxListTileModel(
          id: 3,
          img:
              'https://m.media-amazon.com/images/G/01/seo/siege-lists/best-comedy-audiobooks-mobile._CB1576523493_.png',
          title: "Comedy",
          isCheck: false),
      CheckBoxListTileModel(
          id: 4,
          img:
              'https://static.wikia.nocookie.net/aesthetics/images/c/cd/Fantasy_World.jpg/revision/latest?cb=20201122150254',
          title: "Fantasy",
          isCheck: false),
      CheckBoxListTileModel(
          id: 5,
          img:
              'https://assets-eu-01.kc-usercontent.com/bcd02f72-b50c-0179-8b4b-5e44f5340bd4/ccdb3a19-7024-4aa5-8412-d8b74a189760/Introduction-to-science-fiction-The-best-sci-fi-books-for-newbies-to-the-genre-Header.jpg',
          title: "Sci-Fi",
          isCheck: false),
      CheckBoxListTileModel(
          id: 6,
          img:
              "https://esenler.bel.tr/wp-content/uploads/2021/08/yaratici-drama.jpg",
          title: "Drama",
          isCheck: false),
      CheckBoxListTileModel(
          id: 7,
          img:
              'https://www.rollingstone.com/wp-content/uploads/2016/10/DontBreathe.jpg?w=800',
          title: "Thriller",
          isCheck: false),
      CheckBoxListTileModel(
          id: 8,
          img:
              'https://icdn.ensonhaber.com/resimler/diger/kok/2019/01/23/vumov_7030.jpg',
          title: "Western",
          isCheck: false),
      CheckBoxListTileModel(
          id: 9,
          img:
              'https://thecastleskeep.com/wp-content/uploads/2020/03/Mystery-and-Crime.jpg',
          title: "Crime",
          isCheck: false),
    ];
  }
}
