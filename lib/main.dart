import 'package:employee_app/core/theme/theme.dart';
import 'package:employee_app/data/database/isar.dart';
import 'package:employee_app/ui/all_employees.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'logic/cubits/employees_cubit.dart';
import 'logic/cubits/employees_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _isar();

  runApp(ScreenUtilInit(
    designSize: Size(428, 926),
    builder: (context, child) => MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) =>
              EmployeesCubit()..getEmployees()), // ✅ Ensure Cubit is created

      // Ensure this is called
    ], child: const MyApp()),
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
        title: 'Realtime Innovations Employee App',
        theme: appTheme,
        home: AllEmployees());
  }
}
