import 'package:isar/isar.dart';

part 'employee.g.dart';

@Collection()
class Employee {
  int id = Isar.autoIncrement;
  @Index(type: IndexType.value)
  late String name;
  late String role;
  late DateTime startDate;
  late DateTime? endDate;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  Employee copyWith({
    String? name,
    String? role,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Employee(
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Employee.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        role = json['role'] as String,
        startDate = json['startDate'] as DateTime,
        endDate = json['endDate'] as DateTime?;

  Map<String, dynamic> toJson() =>
      {'name': name, 'role': role, 'startDate': startDate, 'endDate': endDate};
}
