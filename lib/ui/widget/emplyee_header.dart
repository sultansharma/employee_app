import 'package:employee_app/core/const.dart';
import 'package:employee_app/core/widgets/addaptiveText.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, String title) {
  return ListTile(
    tileColor: AppColors.border,
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: adaptiveText(
          context,
          extra: 1,
        ),
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
