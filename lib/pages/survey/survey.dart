import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/survey_lists.dart';

class SurveyPage extends StatefulWidget {
  SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int selectedIndex = -1;
  int listIndex = 0;

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
      body: bodyContent(),
    );
  }

  bodyContent() {
    return Column(
      children: [
        Card(
          child: ListTile(
            selectedTileColor: Colors.blue[100],
            title: Center(
                child: Text(
              "What you want to do?",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(color: Colors.black, fontSize: 24),
              ),
            )),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: listSelect().length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  selected: selectedIndex == index ? true : false,
                  selectedTileColor: Colors.blue[100],
                  title: Text(
                    listSelect()[index],
                    style: GoogleFonts.mcLaren(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                listIndex++;
              });
            },
            child: Text(
              "Next",
              style: GoogleFonts.mcLaren(
                textStyle: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  listSelect() {
    switch (listIndex) {
      case 0:
        return mainList;
      case 1:
        return movieQ1;
      default:
    }
  }
}
