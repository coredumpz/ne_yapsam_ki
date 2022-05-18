import 'package:date_time_picker/date_time_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/components/snackbar.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb_user.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ne_yapsam_ki/models/mongoDB_user_model.dart';

import '../../components/custom_button.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  SignUpWidget({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dateController = TextEditingController();

  String? horoscope = "Taurus";
  Gender? gender = Gender.Male;
  String? date;
  late int age;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.of(context).popAndPushNamed("/landing"),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sign up',
                style: GoogleFonts.mcLaren(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLines: 1,
                            controller: emailController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'E-mail',
                              prefixIcon: const Icon(Icons.mail),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? "Enter a valid email"
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? "Enter min. 6 characters"
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: DateTimePicker(
                        decoration: InputDecoration(
                          hintText: 'Select your birthday',
                          prefixIcon: const Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        type: DateTimePickerType.date,
                        controller: dateController,
                        firstDate: DateTime(1923),
                        lastDate: DateTime(2023),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Birth Date',
                        onChanged: (val) => setState(() => date = val),
                        onSaved: (val) => setState(() => date = val),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Horoscope : ",
                          style: GoogleFonts.mcLaren(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: horoscope,
                          items: horoscopes.map(buildMenuItem).toList(),
                          onChanged: (value) =>
                              setState(() => this.horoscope = value),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GenderPickerWithImage(
                      verticalAlignedText: false,
                      selectedGender: Gender.Male,
                      selectedGenderTextStyle: const TextStyle(
                          color: Color(0xFF8b32a8),
                          fontWeight: FontWeight.bold),
                      unSelectedGenderTextStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      onChanged: (Gender? _gender) {
                        gender = _gender;
                      },
                      equallyAligned: true,
                      animationDuration: const Duration(milliseconds: 300),
                      isCircular: true,
                      // default : true,
                      opacityOfGradient: 0.4,
                      padding: const EdgeInsets.all(3),
                      size: 50, //default : 40
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                      text: 'Sign Up',
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                      ),
                      onPressed: signUp,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: "Log In",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    // CHECK FOR VALIDATION
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    // CREATE USER ACCOUNT
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _insertData(ageCalculate(date.toString()), horoscope.toString(),
          gender.toString().substring(7));
    } on FirebaseAuthException catch (e) {
      //Utils.showSnackBar(e.message);
    }
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.mcLaren(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      );

  int ageCalculate(String date) {
    int year = int.parse(date.substring(0, 4));
    age = 2022 - year;
    return age;
  }

  Future<void> _insertData(int age, String horoscope, String gender) async {
    String UUID = FirebaseAuth.instance.currentUser!.uid;
    List movieFav = [];
    List seriesFav = [];
    List bookFav = [];
    List recipeFav = [];
    List gameFav = [];

    var _id = M.ObjectId();
    final data = MongoDBUserModel(
      id: _id,
      UUID: UUID,
      age: age,
      gender: gender,
      horoscope: horoscope,
      movieFav: movieFav,
      seriesFav: seriesFav,
      bookFav: bookFav,
      recipeFav: recipeFav,
      gameFav: gameFav,
    );
    await MongoDBInsert.insert(data);
  }
}
