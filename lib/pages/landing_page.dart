import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/auth/auth.dart';
import 'package:ne_yapsam_ki/components/custom_button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _buildContent(context),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      margin: const EdgeInsets.symmetric(
        vertical: 50.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            "assets/images/love.png",
            width: 250,
            height: 250,
            scale: 1,
          ),
          Image.asset(
            "assets/images/text.png",
            scale: 1,
          ),
          CustomElevatedButton(
            text: 'Sign In',
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                "/login",
              );
            },
          ),
          TextButton(
            onPressed: () async {
              bool isAnon = await AuthService.signInAnon();
              if (isAnon) {
                Navigator.of(context).pushNamed(
                  "/homepage",
                );
              }
            },
            child: const Text(
              "Continue without Sign in",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
