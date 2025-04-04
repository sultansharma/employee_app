class Employee {
  late String? id;
  late String name;
  late String role;
  late DateTime startDate;
  DateTime? endDate;

  Employee({
    this.id,
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
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  factory Employee.fromMap(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
