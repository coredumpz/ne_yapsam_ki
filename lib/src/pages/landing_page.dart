import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';

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
      padding: const EdgeInsets.all(60.0),
      margin: const EdgeInsets.symmetric(
        vertical: 80.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            "assets/images/aa.png",
            scale: 2,
          ),
          // const Text(
          //   "NE YAPSAM Kİ",
          //   style: TextStyle(
          //     color: Colors.red,
          //     fontSize: 35,
          //     fontStyle: FontStyle.italic,
          //   ),
          // ),
          SignInButtonBuilder(
            text: 'Sign in with Email',
            icon: Icons.email,
            onPressed: () {
              Navigator.of(context).pushNamed(
                "/login",
              );
            },
            backgroundColor: Colors.blueGrey[700]!,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                "/homepage",
              );
            },
            child: const Text("Continue without login"),
          ),
        ],
      ),
    );
  }
}
