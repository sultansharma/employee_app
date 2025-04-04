import 'package:employee_app/core/widgets/hexColor.dart';
import 'package:flutter/material.dart';

class AppStrings {
  static String curEmployees = "Current employees";
  static String prevEmployees = "Previous employees";
  static String cancel = "Cancel";
  static String toDelete = "Swipe left to delete";
  static String save = "Save";
  //Errors
  static String endDateShouldOlder = "End date can't be before Start date";
  static String fillAll = 'Please fill all details !';
  static String correctName =
      'Name can only contain letters and numbers, no symbols allowed';
  static String selectStartDateFirst = "Please select start date first!";
  static String selectRole = "Please select role!";
}

class AppColors {
  static Color primary = hexToColor("#1DA1F2");
  static Color lightBlue = hexToColor("#EDF8FF");
  static Color selectRoleColor = hexToColor("#323238");
  static Color border = hexToColor("#E5E5E5");
  static const Color textHint = Color(0xFF949C9E);
  static const Color bgGrey = Color(0xFFF2F2F2);
  static const Color subTitle = Color(0xFF949C9E);
}

class AppAssets {
  // Images
  static const String noEmployee = 'assets/images/no_employee.png';
  // Icons
  static const String jobRoleIcon = 'assets/icons/job_role.svg';
  static const String arrowDownIcon = 'assets/icons/arrow_down.svg';
  static const String arrowRightIcon = 'assets/icons/arrow_right.svg';
  static const String calendarIcon = 'assets/icons/calendar.svg';
  static const String employeeIcon = 'assets/icons/employee.svg';
  static const String removeIcon = 'assets/icons/remove.svg';

  //Month Prev Next
  static const String arrowPrevIcon = 'assets/icons/arrow_prev.svg';
  static const String arrowNextIcon = 'assets/icons/arrow_next.svg';
}
