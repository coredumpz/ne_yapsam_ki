import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/models/series/series_model.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/series_more.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';

import '../../constants/globals.dart';
import '../../models/movie/movie_model.dart';
import '../movies_TMDB/description.dart';

class TvSeries extends StatelessWidget {
  final List<Series> series;
  final String title;

  const TvSeries({required this.series, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
                                builder: (context) => MoreSeries(
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
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: series.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TvDescription(
                              series: series[index],
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
                                      series[index].posterPath == null
                                          ? URL_DEFAULT
                                          : TMDB_URL_BASE +
                                              series[index].posterPath!),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              height: 200,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              child: Text(
                                series[index].title ?? "null",
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
                  }))
        ],
      ),
    );
  }
}
