import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String name, description, bannerurl, posterurl, vote, launch_on;

  const Description(
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
                      bannerurl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(
                    '⭐ Average Rating - ' + vote,
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
              'Releasing On - ' + launch_on,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Row(
            children: [
              Container(
                height: 200,
                width: 100,
                child: Image.network(posterurl),
              ),
              Flexible(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      description,
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
