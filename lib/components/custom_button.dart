import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/constants/theme_data.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final ButtonStyle? style;

  const CustomElevatedButton(
      {key, required this.onPressed, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: accentColorC),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
      ),
      onPressed: onPressed,
    );
  }
}
