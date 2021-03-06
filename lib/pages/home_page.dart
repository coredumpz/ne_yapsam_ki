import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/components/dialogs/show_alert_dialog.dart';
import 'package:ne_yapsam_ki/pages/books/books_home.dart';
import 'package:ne_yapsam_ki/pages/food/recipe_home.dart';
import 'package:ne_yapsam_ki/pages/games/game_home.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_TMDB.dart';

import 'movies_TMDB/homeTMDB.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: buildContent(),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/images/menu.svg'),
        onPressed: () {
          _drawerKey.currentState?.openDrawer();
        },
      ),
      centerTitle: true,
      title: Image.asset(
        "assets/images/text.png",
        scale: 1.5,
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed("/survey"),
          icon: const Icon(
            FontAwesomeIcons.clipboardList,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pushNamed("/wheel"),
          icon: const Icon(
            FontAwesomeIcons.dice,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Image.asset(
              "assets/images/text.png",
              scale: 1.5,
            ),
          ),
          const Divider(),
          Center(
            child: Text(
              user!.isAnonymous
                  ? "You are not signed in."
                  : "User Email: " + user!.email.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const Divider(),
          _createDrawerItem(
            icon: FontAwesomeIcons.userAlt,
            text: 'My Account',
            onTap: () {
              user!.isAnonymous
                  ? showAlertDialog(
                      context,
                      content: "You have to sign in first!",
                      defaultActionText: "Ok",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).popAndPushNamed("/login");
                      },
                      cancelActionText: "Cancel",
                      onPressedCancel: () => Navigator.of(context).pop(),
                    )
                  : Navigator.of(context).pushNamed("/profile");
            },
          ),
          _createDrawerItem(
              icon: FontAwesomeIcons.solidHeart,
              text: 'Favorites',
              onTap: () {
                user!.isAnonymous
                    ? showAlertDialog(
                        context,
                        content: "You have to sign in first!",
                        defaultActionText: "Ok",
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).popAndPushNamed("/login");
                        },
                        cancelActionText: "Cancel",
                        onPressedCancel: () => Navigator.of(context).pop(),
                      )
                    : Navigator.of(context).pushNamed("/favorite");
              }),
          _createDrawerItem(
            icon: FontAwesomeIcons.dice,
            text: 'Luck Wheel',
            onTap: () => Navigator.of(context).pushNamed("/wheel"),
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.clipboardList,
            text: 'Let Me Help',
            onTap: () => Navigator.of(context).pushNamed("/survey"),
          ),
          const Divider(),
          user!.isAnonymous
              ? _createDrawerItem(
                  icon: FontAwesomeIcons.signInAlt,
                  text: 'Sign In',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).popAndPushNamed("/login");
                  })
              : _createDrawerItem(
                  icon: FontAwesomeIcons.signOutAlt,
                  text: 'Sign Out',
                  onTap: () async {
                    showAlertDialog(
                      context,
                      content: "Do you really want to sign out?",
                      defaultActionText: "Yes",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("You are successfully signed out."),
                        ));
                        Navigator.of(context).popAndPushNamed("/login");
                      },
                      cancelActionText: "No",
                      onPressedCancel: () => Navigator.of(context).pop(),
                    );
                  }),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData? icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  buildContent() {
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Column(
          children: <Widget>[
            ButtonsTabBar(
              backgroundColor: Colors.red,
              unselectedBackgroundColor: Colors.grey[300],
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  icon: Icon(Icons.movie),
                  text: "Movies",
                ),
                Tab(
                  icon: Icon(Icons.tv_outlined),
                  text: "TV Series",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.book),
                  text: "Books",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.utensils),
                  text: "Recipes",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.gamepad),
                  text: " Games",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  HomeTMDB(),
                  TvTMDB(),
                  BooksHome(),
                  RecipeHome(),
                  HomeGame(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
