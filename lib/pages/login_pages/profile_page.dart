import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/models/mongoDB_user_model.dart';

import '../../dbHelper/mongodb_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late MongoDBUserModel userInfo;
  bool _isLoading = true;

  late String email;
  List<String> userInfoList = [];
  List<String> userInfoCard = [
    "E-Mail: ",
    "Age: ",
    "Horoscope: ",
    "Gender: ",
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  loadUserData() async {
    final response = await MongoDBInsert.userData(getUUID());

    userInfo = MongoDBUserModel.fromJson(response[0]);

    userInfoList.add(email);
    userInfoList.add(userInfo.age.toString());
    userInfoList.add(userInfo.horoscope);
    userInfoList.add(userInfo.gender);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Profile",
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
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
    return Card(
      margin: EdgeInsets.all(20.0),
      elevation: 40,
      child: ListView.builder(
        itemCount: userInfoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userInfoCard[index],
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      userInfoList[index],
                      style: GoogleFonts.mcLaren(
                        textStyle: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  getUUID() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user!.uid;

    email = user.email!;

    return uid;
  }

  Future<void> getUserInfo() async {
    await MongoDBInsert.userData(getUUID());
  }
}
