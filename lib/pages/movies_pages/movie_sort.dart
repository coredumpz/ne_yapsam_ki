import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/components/custom_button.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/models/checkbox_model.dart';
import 'package:ne_yapsam_ki/utils/provider.dart';
import 'package:provider/provider.dart';

class CheckBoxListTileDemo extends StatefulWidget {
  @override
  CheckBoxListTileDemoState createState() => CheckBoxListTileDemoState();
}

class CheckBoxListTileDemoState extends State<CheckBoxListTileDemo> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getGenres();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () => Navigator.pop(context),
            iconSize: 30,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Choose Genre',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 550,
              child: ListView.builder(
                itemCount: checkBoxListTileModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CheckboxListTile(
                            activeColor: Colors.pink[300],
                            dense: true,
                            //font change
                            title: Text(
                              checkBoxListTileModel[index].title,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5),
                            ),
                            value: checkBoxListTileModel[index].isCheck,
                            secondary: SizedBox(
                              height: 50,
                              width: 100,
                              child: Image.network(
                                  checkBoxListTileModel[index].img),
                            ),
                            onChanged: (val) {
                              checkBoxListTileModel[index].isCheck =
                                  !checkBoxListTileModel[index].isCheck;
                              itemChange(val!, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    Provider.of<WheelProvider>(context, listen: false)
                        .setSortButtonPressed = true;
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(
                      "/homepage",
                    );
                  },
                  text: "Sort",
                ),
                const SizedBox(
                  width: 30,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    Provider.of<WheelProvider>(context, listen: false)
                        .setSortButtonPressed = false;
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(
                      "/homepage",
                    );
                  },
                  text: "See all movies",
                ),
              ],
            ),
          ],
        ));
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
      selectedGenres.remove("movie");

      if (checkBoxListTileModel[index].isCheck) {
        selectedGenres.add(checkBoxListTileModel[index].title);
      } else if (!checkBoxListTileModel[index].isCheck &&
          selectedGenres.contains(checkBoxListTileModel[index].title)) {
        selectedGenres.remove(checkBoxListTileModel[index].title);
      }
    });
  }
}
