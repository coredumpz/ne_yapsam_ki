import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/survey/movie/movie_survey_result.dart';

import '../../../constants/survey_lists.dart';

class MovieSurvey extends StatefulWidget {
  MovieSurvey({Key? key}) : super(key: key);

  @override
  State<MovieSurvey> createState() => _MovieSurveyState();
}

class _MovieSurveyState extends State<MovieSurvey> {
  String? genre = "Action";
  String? duration;
  String? movieDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFA),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: buildContent(),
    );
  }

  buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pick Genre : ",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              value: genre,
              items: movieGenreList.map(buildMenuItem).toList(),
              onChanged: (value) => setState(() => this.genre = value),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Date of the movie?",
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomRadioButton(
                elevation: 0,
                absoluteZeroSpacing: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: const [
                  'Latest',
                  'Old',
                  'Both',
                ],
                buttonValues: const [
                  "LATEST",
                  "OLD",
                  "BOTH",
                ],
                buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 18)),
                radioButtonValue: (value) {
                  movieDate = value.toString();
                  print(value);
                },
                selectedColor: Theme.of(context).accentColor,
                width: 100,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Duration of the movie?",
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomRadioButton(
                elevation: 0,
                absoluteZeroSpacing: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: const [
                  'Long',
                  'Short',
                  'Both',
                ],
                buttonValues: const [
                  "LONG",
                  "SHORT",
                  "BOTH",
                ],
                buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 18)),
                radioButtonValue: (value) {
                  duration = value.toString();

                  print(value);
                },
                selectedColor: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
        ElevatedButton(
          child: const Text(
            "FIND",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieSurveyResult(
                        duration: duration.toString(),
                        genre: genre.toString(),
                        movieDate: movieDate.toString(),
                      )),
            );
          },
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      );
}
