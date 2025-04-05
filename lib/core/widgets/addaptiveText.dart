import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle adaptiveStyle(BuildContext context, {Color? color}) {
  final width = MediaQuery.of(context).size.width;
  final isLandscape =
      MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

  double fontSize;

  if (width >= 1024) {
    // Desktop
    fontSize = 6.sp;
  } else if (width >= 600) {
    // Tablet (e.g. iPad)
    fontSize = isLandscape ? 6.sp : 10.sp;
  } else {
    // Mobile
    fontSize = 13.sp;
  }

  return TextStyle(
      fontSize: fontSize, color: color ?? Colors.white // or AppColors.primary
      );
}

double adaptiveText(BuildContext context, {num extra = 0}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final isLandscape = width > height;

  if (width >= 1024) {
    return extra + 5.sp; // Desktop
  } else if (width >= 600) {
    return isLandscape ? extra + 6.sp : extra + 11.sp; // Tablet
  } else {
    return extra + 13.sp; // Mobile
  }
}

double adaptiveSp(BuildContext context, {double factor = 1.0}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final isLandscape = width > height;

  double baseSp;

  if (width >= 1024) {
    // Desktop
    baseSp = 14.0;
  } else if (width >= 600) {
    // Tablet (e.g., iPad)
    baseSp = isLandscape ? 14 : 14.0;
  } else {
    // Mobile
    baseSp = 11.0;
  }

  // Apply scaling factor if needed (e.g., for slight adjustments)
  return baseSp * factor;
}
