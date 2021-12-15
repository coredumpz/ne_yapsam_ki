import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        elevation: 2.0,
        backgroundColor: Colors.red[800],
      ),
      body: Center(
        child: SizedBox(
          width: 540,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  primary: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        "Abone Girişi",
                        textScaleFactor: 1.5,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Kullanıcı Kodu",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen kullanıcı kodunu giriniz!';
                          }
                          return null;
                        },
                        controller: username,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Parola",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen parolayı giriniz!';
                          }
                          return null;
                        },
                        controller: password,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: forgotPressed,
                            child: const Text("Şifremi Unuttum"),
                          ),
                          ElevatedButton(
                            onPressed: loginPressed,
                            child: const Text("Oturum Aç"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            "/homepage",
                          );
                        },
                        child: const Text("Giriş yapmadan devam et"),
                      ),
                      LoadingButton(
                        defaultWidget: const Text('Click Me'),
                        width: 196,
                        height: 60,
                        onPressed: () async {
                          await Future.delayed(
                            const Duration(milliseconds: 1500),
                          );
                          Navigator.of(context).pushNamed("/homepage");
                        },
                      ),
                      RoundedLoadingButton(
                          child: const Text('Tap me!',
                              style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: () {
                            _doSomething;
                            _btnController.success();
                            Navigator.of(context).pushNamed("/homepage");
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginPressed() {}

  void demoPressed() {}

  void forgotPressed() {}

  void _doSomething() async {
    Timer(const Duration(seconds: 3), () {
      _btnController.success();
    });
  }
}
