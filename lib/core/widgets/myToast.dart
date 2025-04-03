import 'package:flutter/material.dart';

myToast(BuildContext context, {String? text, String type = "error"}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: type == "error" ? Colors.redAccent : Colors.greenAccent,
      content: Text(text ?? "Error"),
    ),
  );
}
