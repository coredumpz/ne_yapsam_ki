import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ne_yapsam_ki/dbHelper/mongodb.dart';
import 'package:ne_yapsam_ki/models/mongoDBModel.dart';

class MongoDBInsert extends StatefulWidget {
  MongoDBInsert({Key? key}) : super(key: key);

  @override
  State<MongoDBInsert> createState() => _MongoDBInsertState();
}

class _MongoDBInsertState extends State<MongoDBInsert> {
  var fnameController = new TextEditingController();
  var lnameController = new TextEditingController();
  var addressController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                "Insert Data",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: fnameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lnameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: addressController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      //_fakeData();
                    },
                    child: const Text("Generate Data"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      /*_insertData(fnameController.text, lnameController.text,
                          addressController.text);*/
                    },
                    child: const Text("Insert Data"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
  Future<void> _insertData(String fname, String lname, String address) async {
    var _id = M.ObjectId(); // This will used for unique ID
    final data = MongoDbModel(
        id: _id, firstName: fname, lastName: lname, address: address);
    var result = await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Inserted ID " + _id.$oid),
      ),
    );
    _clearALL();
  }

  void _clearALL() {
    fnameController.text = "";
    lnameController.text = "";
    addressController.text = "";
  }

  void _fakeData() {
    setState(() {
      fnameController.text = faker.person.firstName();
      lnameController.text = faker.person.lastName();
      addressController.text =
          faker.address.streetName() + "\n" + faker.address.streetAddress();
    });
  }*/
}
