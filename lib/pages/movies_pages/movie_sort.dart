import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/components/custom_button.dart';
import 'package:ne_yapsam_ki/models/checkbox_model.dart';

class CheckBoxListTileDemo extends StatefulWidget {
  @override
  CheckBoxListTileDemoState createState() => CheckBoxListTileDemoState();
}

class CheckBoxListTileDemoState extends State<CheckBoxListTileDemo> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();

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
                            secondary: Container(
                              height: 50,
                              width: 100,
                              child: Image.network(
                                  checkBoxListTileModel[index].img),
                            ),
                            onChanged: (val) {
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
            CustomElevatedButton(
              onPressed: () {},
              text: "Sort",
            ),
          ],
        ));
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }
}
