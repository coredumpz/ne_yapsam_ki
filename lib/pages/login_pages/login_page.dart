import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ne_yapsam_ki/components/round_btn.dart';
import 'package:ne_yapsam_ki/components/text_input_field.dart';
import 'package:ne_yapsam_ki/constants/theme_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ), // Top bar color
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: primaryColorC,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 0.0,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 30, color: textColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 40),
                      child: Text(
                        'Email',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Column(
                      children: const [
                        CustomTextInput(
                          3,
                          'Enter email here',
                          false,
                          Icons.person,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 18),
                      child: Text(
                        'Password',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: CustomTextInput(
                      4,
                      'Enter password here',
                      true,
                      Icons.vpn_key,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: CustomButton(1, 'Login'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        "/homepage",
                      );
                    },
                    child: const Text(
                      "Continue without login",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    '- OR -',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const Text(
                    'Sign in with',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth: 10,
                          color: Colors.white,
                          onPressed: () {},
                          child: Image.asset(
                            'assets/images/icon_facebook_48.png',
                            height: 30,
                            width: 30,
                          ),
                          shape: const CircleBorder(),
                        ),
                        MaterialButton(
                          minWidth: 10,
                          color: Colors.white,
                          onPressed: () {},
                          child: Image.asset(
                            'assets/images/icon_google_48.png',
                            height: 30,
                            width: 30,
                          ),
                          shape: const CircleBorder(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?  ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              "/signup",
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
