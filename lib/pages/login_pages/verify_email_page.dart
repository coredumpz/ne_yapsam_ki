import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/home_page.dart';

import '../../components/snackbar.dart';
import '../../dbHelper/mongodb.dart';
import '../../dbHelper/mongodb_user.dart';

class VerifyEmailPage extends StatefulWidget {
  VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // user needs to be created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => {
          checkEmailVerified(),
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState((() => canResendEmail = false));
      await Future.delayed(const Duration(seconds: 5));
      setState((() => canResendEmail = true));
    } catch (e) {
      // Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
              title: Text("Verify Email"),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () => Navigator.pop(context),
                iconSize: 30,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A verification email has been sent to your email.",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(Icons.email),
                    label: const Text("Resent Email"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
