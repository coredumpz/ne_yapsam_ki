import 'package:date_time_picker/date_time_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/components/snackbar.dart';
import 'package:ne_yapsam_ki/constants/globals.dart';
import 'package:ne_yapsam_ki/dbHelper/mongodb_user.dart';
import 'package:ne_yapsam_ki/main.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ne_yapsam_ki/models/mongoDB_user_model.dart';

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
    return Card(
      color: Colors.amber,
      //backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 120,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter a valid email"
                        : null,
              ),
              const SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? "Enter min. 6 characters"
                    : null,
              ),
              const SizedBox(
                height: 4,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Horoscope : "),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: horoscope,
                        items: horoscopes.map(buildMenuItem).toList(),
                        onChanged: (value) =>
                            setState(() => this.horoscope = value),
                      ),
                    ],
                  ),
                ],
              ),
              GenderPickerWithImage(
                verticalAlignedText: false,
                selectedGender: Gender.Male,
                selectedGenderTextStyle: const TextStyle(
                    color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
                unSelectedGenderTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
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
              DateTimePicker(
                type: DateTimePickerType.date,
                controller: dateController,
                firstDate: DateTime(1923),
                lastDate: DateTime(2023),
                icon: const Icon(Icons.event),
                dateLabelText: 'Birth Date',
                onChanged: (val) => setState(() => date = val),
                onSaved: (val) => setState(() => date = val),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  signUp();
                },
                icon: const Icon(Icons.lock_open),
                label: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: "Log In",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.background,
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
      _insertData(ageCalculate(date.toString()), horoscope.toString(),
          gender.toString().substring(7));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
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

    var _id = M.ObjectId();
    final data = MongoDBUserModel(
        id: _id, UUID: UUID, age: age, gender: gender, horoscope: horoscope);
    var result = await MongoDBInsert.insert(data);
    dispose();
  }
}
