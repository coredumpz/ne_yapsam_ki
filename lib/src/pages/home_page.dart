import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 2.0,
        backgroundColor: Colors.red[800],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
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
                // ignore: prefer_const_literals_to_create_immutables
                tabs: [
                  const Tab(
                    icon: Icon(Icons.movie),
                    text: "Movies",
                  ),
                  const Tab(
                    icon: Icon(Icons.tv_outlined),
                    text: "TV Series",
                  ),
                  const Tab(
                    icon: Icon(FontAwesomeIcons.book),
                    text: "Books",
                  ),
                  const Tab(
                    icon: Icon(FontAwesomeIcons.utensils),
                    text: "Food",
                  ),
                  const Tab(
                    icon: Icon(FontAwesomeIcons.gamepad),
                    text: " Games",
                  ),
                  const Tab(
                    icon: Icon(FontAwesomeIcons.music),
                    text: "Song",
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Center(
                      child: Icon(Icons.movie),
                    ),
                    Center(
                      child: Icon(Icons.tv_outlined),
                    ),
                    Center(
                      child: Icon(FontAwesomeIcons.book),
                    ),
                    Center(
                      child: Icon(FontAwesomeIcons.utensils),
                    ),
                    Center(
                      child: Icon(FontAwesomeIcons.gamepad),
                    ),
                    Center(
                      child: Icon(FontAwesomeIcons.music),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
