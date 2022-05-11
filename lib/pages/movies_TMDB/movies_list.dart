import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/pages/movies_TMDB/movies_more.dart';

import '../../models/movie/movie_model.dart';
import 'description.dart';

class MoviesList extends StatelessWidget {
  final List<Movie> movies;
  final String title;

  const MoviesList({required this.movies, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.mcLaren(
                  textStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const Spacer(),
              title != "You may like these also... "
                  ? Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MoreMovies(
                                      title: title,
                                    )),
                          );
                        },
                        child: Text(
                          "See More..",
                          style: GoogleFonts.mcLaren(
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 10),
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
                        builder: (context) => MovieDescription(
                          movie: movies[index],
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
                                movies[index].posterPath != null
                                    ? TMDB_URL_BASE + movies[index].posterPath!
                                    : URL_DEFAULT,
                              ),
                            ),
                          ),
                          height: 200,
                        ),
                        SizedBox(height: 5),
                        Container(
                          child: Text(
                            movies[index].title ?? "Not Avaliable",
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
