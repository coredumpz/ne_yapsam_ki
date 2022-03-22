import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'description.dart';

class MoviesList extends StatelessWidget {
  final List movies;
  final String title;

  const MoviesList({required this.movies, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + " Movies",
            style: GoogleFonts.mcLaren(
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: movies[index]['title'],
                          bannerurl: 'https://image.tmdb.org/t/p/w500' +
                              movies[index]['backdrop_path'],
                          posterurl: 'https://image.tmdb.org/t/p/w500' +
                              movies[index]['poster_path'],
                          description: movies[index]['overview'],
                          vote: movies[index]['vote_average'].toString(),
                          launch_on: movies[index]['release_date'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500' +
                                      movies[index]['poster_path']),
                            ),
                          ),
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: Text(
                            movies[index]['title'] ?? 'Loading',
                            style: GoogleFonts.mcLaren(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 14.5),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
