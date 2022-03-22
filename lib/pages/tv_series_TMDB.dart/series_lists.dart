import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/tv_series_TMDB.dart/tv_description.dart';

import '../../constants/globals.dart';
import '../movies_TMDB/description.dart';

class TvSeries extends StatelessWidget {
  final List series;
  final String title;

  const TvSeries({required this.series, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title + ' Series',
            style: GoogleFonts.mcLaren(
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
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
                              name: series[index]['original_name'],
                              bannerurl: 'https://image.tmdb.org/t/p/w500' +
                                  series[index]['backdrop_path'],
                              posterurl: 'https://image.tmdb.org/t/p/w500' +
                                  series[index]['poster_path'],
                              description: series[index]['overview'],
                              vote: series[index]['vote_average'].toString(),
                              launch_on: series[index]['first_air_date'],
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
                                      series[index]['poster_path'] == null
                                          ? URL_DEFAULT
                                          : 'https://image.tmdb.org/t/p/w500' +
                                              series[index]['poster_path']),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              height: 200,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              child: Text(
                                series[index]['original_name'] != null
                                    ? series[index]['original_name']
                                    : 'Loading',
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
