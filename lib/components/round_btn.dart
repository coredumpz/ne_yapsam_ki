import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/theme_data.dart';
import 'dialogs/show_alert_dialog.dart';

class CustomButton extends StatelessWidget {
  final int _iD;
  final String _btnText;
  // final String _inputUsername;
  // final String _inputPassword;
  const CustomButton(this._iD, this._btnText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
        ),
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: Colors.white,*/
        child: Text(
          _btnText,
          style: const TextStyle(fontSize: 16, color: accentColorC),
        ),
        onPressed: () {
          if (_iD == 1) {
            showAlertDialog(
              context,
              title: "Success",
              content: "Sign In was successful",
              defaultActionText: "Ok",
              onPressed: () => Navigator.of(context).pushNamed("/homepage"),
            );
          } else {
            showAlertDialog(
              context,
              title: "Success",
              content: "Sign Up was successful",
              defaultActionText: "Ok",
            );
          }
        },
      ),
    );
  }
}
