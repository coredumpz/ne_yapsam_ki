import 'package:flutter/material.dart';

Future showAlertDialog(
  BuildContext context, {
  String? title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
  VoidCallback? onPressed,
  VoidCallback? onPressedCancel,
  bool? dismissable,
}) {
  return showDialog(
    barrierDismissible: dismissable == null,
    context: context,
    builder: (context) => AlertDialog(
      title: title != null ? Text(title) : null,
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          TextButton(
            child: Text(cancelActionText),
            onPressed: onPressedCancel,
          ),
        TextButton(
          child: Text(defaultActionText),
          onPressed: onPressed,
        ),
      ],
    ),
  );
}
