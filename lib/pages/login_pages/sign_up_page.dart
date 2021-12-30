import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ne_yapsam_ki/components/round_btn.dart';
import 'package:ne_yapsam_ki/components/text_input_field.dart';

import 'package:ne_yapsam_ki/constants/theme_data.dart';

class SingUpPage extends StatelessWidget {
  const SingUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: primaryColorC,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 30, color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 20),
                      child: Text(
                        'Full Name',
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
                          1,
                          'Enter your name',
                          false,
                          Icons.person,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 15),
                      child: Text(
                        'Age',
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
                      2,
                      'Enter your Age',
                      false,
                      Icons.calendar_today_sharp,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 15),
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
                          'Enter your Email',
                          false,
                          Icons.mail,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 15),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Column(
                      children: const [
                        CustomTextInput(
                          4,
                          'Enter your password',
                          true,
                          Icons.vpn_key,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, right: 5, top: 15),
                      child: Text(
                        'Confirm Password',
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
                          5,
                          'Confirm password',
                          true,
                          Icons.vpn_key,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: CustomButton(2, 'Sign Up'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Have an account?  ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: const Text(
                            'Sign In',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
