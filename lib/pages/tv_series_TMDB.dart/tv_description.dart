import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';

class TvDescription extends StatelessWidget {
  final String name, description, bannerurl, posterurl, vote, launch_on;

  const TvDescription(
      {required this.name,
      required this.description,
      required this.bannerurl,
      required this.posterurl,
      required this.vote,
      required this.launch_on});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(children: [
          Container(
              height: 250,
              child: Stack(children: [
                Positioned(
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      bannerurl != null ? bannerurl : URL_DEFAULT,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(
                    vote != null ? '⭐ Average Rating - ' + vote : "null",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ])),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              name != null ? name : 'Not Loaded',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              launch_on != null ? 'Released on - ' + launch_on : "null",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Row(
            children: [
              Container(
                height: 200,
                width: 100,
                child: Image.network(
                  posterurl != null ? posterurl : URL_DEFAULT,
                ),
              ),
              Flexible(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      description != null ? description : "null",
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
