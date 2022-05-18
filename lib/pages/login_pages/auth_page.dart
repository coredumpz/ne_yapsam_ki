import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/login_pages/login_widget.dart';
import 'package:ne_yapsam_ki/pages/login_pages/sign_up_widget.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginWidget(
            onClickedSignUp: toggle,
          )
        : SignUpWidget(
            onClickedSignIn: toggle,
          );
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
