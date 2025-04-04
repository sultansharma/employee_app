import 'package:employee_app/core/const.dart';
import 'package:employee_app/custom_date_picker/widgets/date_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget getFromToDate(DateTime? startDate, DateTime? endDate) {
  String date = "";
  if (startDate != null) {
    var x = DateFormat('d MMM, yyyy').format(startDate);
    if (endDate == null) {
      date = 'From $x';
    } else {
      var y = DateFormat('d MMM, yyyy').format(endDate);
      date = '$x - $y';
    }
  } else {
    date = '';
  }
  return Text(
    date,
    style: const TextStyle(
      color: AppColors.subTitle,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  );
}
