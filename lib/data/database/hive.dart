// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/employee.dart';

// class DatabaseService {
//   static late Box<Employee> employeeBox;
//   static int _lastId = 0;

//   static Future<void> init() async {
//     if (kIsWeb) {
//       await Hive.initFlutter();
//     } else {
//       await Hive.initFlutter();
//     }

//     Hive.registerAdapter(EmployeeAdapter());
//     employeeBox = await Hive.openBox<Employee>('employees');
//     _lastId = _getLastId();
//   }

//   static int getNextId() {
//     return ++_lastId; // Increment the ID for the new employee
//   }

//   static int _getLastId() {
//     int lastId = 0;

//     if (employeeBox.isNotEmpty) {
//       // Iterate over all employees and get the highest id
//       for (var employee in employeeBox.values) {
//         if (employee.id > lastId) {
//           lastId = employee.id;
//         }
//       }
//     }

//     return lastId;
//   }
// }
