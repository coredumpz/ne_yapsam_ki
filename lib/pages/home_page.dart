import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/luck_wheel.dart';

import 'movies_pages/movies.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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
          _createHeader(),
          _createDrawerItem(
            icon: FontAwesomeIcons.home,
            text: 'Home Page',
            onTap: () => Navigator.of(context).pushNamed("/homepage"),
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.userAlt,
            text: 'My Account',
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.solidHeart,
            text: 'Favorites',
          ),
          _createDrawerItem(
            icon: FontAwesomeIcons.dice,
            text: 'Spinner',
            onTap: () => Navigator.of(context).pushNamed("/wheel"),
          ),
          _createDrawerItem(
            icon: Icons.face,
            text: 'Suggestions',
          ),
          const Divider(),
          _createDrawerItem(
            icon: FontAwesomeIcons.signInAlt,
            text: 'Sign In',
            onTap: () => Navigator.of(context).pushNamed("/login"),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      /*decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/aa.png'),
        ),
      ),*/
      child: Stack(
        children: const <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "Ne Yapsam Ki",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
        length: 6,
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
                  text: "Food",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.gamepad),
                  text: " Games",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.music),
                  text: "Song",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  MoviesPage(),
                  const Center(
                    child: Icon(Icons.tv_outlined),
                  ),
                  const Center(
                    child: Icon(FontAwesomeIcons.book),
                  ),
                  const Center(
                    child: Icon(FontAwesomeIcons.utensils),
                  ),
                  const Center(
                    child: Icon(FontAwesomeIcons.gamepad),
                  ),
                  const Center(
                    child: Icon(FontAwesomeIcons.music),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
