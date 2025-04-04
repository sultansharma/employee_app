import 'package:employee_app/core/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget header(String title) {
  return ListTile(
    tileColor: AppColors.border,
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
