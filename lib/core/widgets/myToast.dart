import 'package:employee_app/core/const.dart';
import 'package:flutter/material.dart';

myToast(BuildContext context,
    {String? text,
    String type = "error",
    bool undo = false,
    dynamic onPressed}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 3000),
      backgroundColor: undo
          ? Colors.black
          : type == "error"
              ? Colors.redAccent
              : Colors.green,
      content: Text(text ?? "Error"),
      action: undo
          ? SnackBarAction(
              label: 'Undo', textColor: AppColors.primary, onPressed: onPressed)
          : null,
    ),
  );
}
