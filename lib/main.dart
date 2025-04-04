import 'package:employee_app/core/theme/theme.dart';
import 'package:employee_app/data/database/isar.dart';
import 'package:employee_app/ui/add_edit_employee.dart';
import 'package:employee_app/ui/all_employees.dart';
import 'package:employee_app/ui/table_desktop_ui/desktop_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'logic/cubits/employees_cubit.dart';
import 'logic/cubits/employees_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _isar();

  runApp(ScreenUtilInit(
    designSize: const Size(428, 926),
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
      debugShowCheckedModeBanner: false,
      title: 'Realtime Innovations Employee App',
      theme: appTheme,
      home: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the screen width is large enough (for example, tablet or larger)
          if (constraints.maxWidth > 800) {
            // Display the widgets side by side on larger screens
            return DesktopUi();
          } else {
            // On smaller screens, stack the widgets vertically
            return AllEmployees(); // Top widget
          }
        },
      ),
    );
  }
}
