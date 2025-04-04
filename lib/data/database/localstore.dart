import 'package:localstore/localstore.dart';
import '../models/employee.dart';

class DatabaseService {
  static final db = Localstore.instance;
  static const String employeeCollection = 'employees';

  // Save or update employee
  static Future<void> saveEmployee(Employee employee) async {
    final collection = db.collection(employeeCollection);

    // If no ID, generate a new one
    employee.id ??= collection.doc().id;

    await collection.doc(employee.id!).set(employee.toMap());
  }

  // Get all employees
  static Future<List<Employee>> getAllEmployees() async {
    final items = await db.collection(employeeCollection).get();
    if (items == null) return [];
    return items.entries.map((entry) => Employee.fromMap(entry.value)).toList();
  }

  // Get employee by ID
  static Future<Employee?> getEmployee(String id) async {
    final map = await db.collection(employeeCollection).doc(id).get();
    if (map == null) return null;
    return Employee.fromMap(map);
  }

  // Delete employee
  static Future<void> deleteEmployee(String id) async {
    await db.collection(employeeCollection).doc(id).delete();
  }
}
