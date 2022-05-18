import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ne_yapsam_ki/pages/login_pages/forgot_password.dart';

import '../../components/custom_button.dart';
import '../../components/snackbar.dart';
import '../../dbHelper/mongodb_user.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  LoginWidget({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                'Sign In',
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
              Column(
                children: [
                  TextField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    text: 'Sign In',
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                    onPressed: signIn,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          text: "Not registered yet? ",
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignUp,
                              text: "Create an account",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You are successfully signed in."),
      ));
    } on FirebaseAuthException catch (e) {
      //Utils.showSnackBar(e.message);
    }

    // navigatorKey.currentState!.popUntil((route) => route.isActive);
  }
}
