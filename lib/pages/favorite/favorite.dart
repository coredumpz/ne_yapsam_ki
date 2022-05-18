import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb_user.dart';
import 'package:ne_yapsam_ki/models/mongoDB_user_model.dart';
import 'package:ne_yapsam_ki/pages/favorite/favorite_books.dart';
import 'package:ne_yapsam_ki/pages/favorite/favorite_games.dart';
import 'package:ne_yapsam_ki/pages/favorite/favorite_movies.dart';
import 'package:ne_yapsam_ki/pages/favorite/favorite_recipes.dart';
import 'package:ne_yapsam_ki/pages/favorite/favorite_series.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late MongoDBUserModel userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  loadUserInfo() async {
    final response = await MongoDBInsert.userData(getUUID());

    userInfo = MongoDBUserModel.fromJson(response[0]);

    setState(() {
      _isLoading = false;
    });
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "My Favorites",
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () => Navigator.pop(context),
                iconSize: 30,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: 0,
              height: 60.0,
              items: const <Widget>[
                Icon(Icons.movie, size: 20),
                Icon(Icons.tv_outlined, size: 20),
                Icon(FontAwesomeIcons.book, size: 20),
                Icon(FontAwesomeIcons.utensils, size: 20),
                Icon(FontAwesomeIcons.gamepad, size: 20),
              ],
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              onTap: (index) {
                setState(() {
                  loadUserInfo();
                  _page = index;
                });
              },
              letIndexChange: (index) => true,
            ),
            body: buildBody(),
          );
  }

  buildBody() {
    switch (_page) {
      case 0:
        return FavoriteMovies(movieList: userInfo.movieFav);
      case 1:
        return FavoriteSeries(seriesList: userInfo.seriesFav);
      case 2:
        return FavoriteBooks(bookList: userInfo.bookFav);
      case 3:
        return FavoriteRecipes(recipeList: userInfo.recipeFav);
      case 4:
        return FavoriteGames(gameList: userInfo.gameFav);

      default:
    }
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
  }
}
