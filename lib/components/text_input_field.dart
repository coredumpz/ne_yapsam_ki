import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/theme_data.dart';
import 'package:ne_yapsam_ki/constants/globals.dart' as globals;

class CustomTextInput extends StatefulWidget {
  final int _iD;
  final String _text;
  final IconData _iconData;
  final bool _obsecure;

  const CustomTextInput(this._iD, this._text, this._obsecure, this._iconData,
      {Key? key})
      : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late String inputUsername;
  late String inputPassword;
  late bool _passMode;
  late bool _obSecure;

  @override
  void initState() {
    super.initState();

    _passMode = widget._obsecure;
    _obSecure = widget._obsecure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 45,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
          color: textFieldBGColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: TextField(
        onChanged: (value) {
          if (!_passMode) {
            switch (widget._iD) {
              case 1:
                globals.inputFullName = value;
                break;
              case 2:
                globals.inputAge = value;
                break;
              case 3:
                globals.inputEmail = value;
                break;
            }
          } else {
            switch (widget._iD) {
              case 4:
                globals.inputPassword = value;
                break;
              case 5:
                globals.inputConfirmPassword = value;
                break;
            }
          }
        },
        obscureText: _obSecure,
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          suffixIcon: _passMode
              ? (_obSecure
                  ? IconButton(
                      icon: const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obSecure = false;
                        });
                      })
                  : IconButton(
                      icon: const Icon(
                        Icons.lock_open,
                        size: 16,
                        color: textColor,
                      ),
                      onPressed: () {
                        if (true) {
                          setState(() {
                            _obSecure = true;
                          });
                        }
                      }))
              : null,
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              widget._iconData,
              color: textColor,
            ),
          ),
          contentPadding:
              const EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 10),
          border: InputBorder.none,
          hintText: widget._text,
          hintStyle: const TextStyle(color: textColor),
        ),
      ),
    );
  }
}
