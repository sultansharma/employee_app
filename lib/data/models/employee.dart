import 'package:isar/isar.dart';

part 'employee.g.dart';

@Collection()
class Employee {
  Id id = Isar.autoIncrement;
  @Index(type: IndexType.value)
  String? name;
  String? role;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
}
