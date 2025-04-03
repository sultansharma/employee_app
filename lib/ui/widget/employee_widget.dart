import 'package:employee_app/data/models/employee.dart';
import 'package:flutter/material.dart';

class EmployeeWidget extends StatelessWidget {
  EmployeeWidget({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  bool isPastEmployee = false;

  String _getDateString() {
    final startDate = employee.startDate;
    final endDate = employee.endDate;

    String dateString = startDate.toString();

    if (isPastEmployee && endDate.toString().isNotEmpty) {
      dateString += ' - $endDate';
    }

    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    final date = _getDateString();

    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onEdit,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name ?? "N/A",
                style: TextStyle(
                  color: const Color(0xFF323238),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                employee.role ?? "N/A",
                style: TextStyle(
                  color: const Color(0xFF949C9E),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  color: const Color(0xFF949C9E),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
