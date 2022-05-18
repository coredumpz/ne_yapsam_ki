import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/home_page.dart';
import 'package:ne_yapsam_ki/pages/login_pages/auth_page.dart';
import 'package:ne_yapsam_ki/pages/login_pages/verify_email_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData && !snapshot.data!.isAnonymous) {
            return VerifyEmailPage();
          } else if (snapshot.hasData && snapshot.data!.isAnonymous) {
            return HomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
