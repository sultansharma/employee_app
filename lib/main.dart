import 'package:employee_app/core/theme/theme.dart';
import 'package:employee_app/data/database/isar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _isar();
  runApp(ScreenUtilInit(
    designSize: Size(428, 926),
    builder: (context, child) => MyApp(),
  ));
}

//Isar Database setup

Future<void> _isar() async {
  await DatabaseService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime-innovations emplyoee app',
      theme: appTheme,
      home: const Text("Starting"),
    );
  }
}
