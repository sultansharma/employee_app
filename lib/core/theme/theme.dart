import 'package:employee_app/data/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData appTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500),
    ),
    colorScheme: ColorScheme.light(primary: AppColors.primary),
    primaryColor: AppColors.primary);
