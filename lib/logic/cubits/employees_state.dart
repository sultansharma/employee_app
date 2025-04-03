import 'package:employee_app/data/models/employee.dart';

abstract class EmployeesState {}

class EmployeesLoadingState extends EmployeesState {}

class EmployeesLoadedState extends EmployeesState {
  final List<Employee> employees;
  EmployeesLoadedState(this.employees);
}

class EmployeesErrorState extends EmployeesState {
  final String error;
  EmployeesErrorState(this.error);
}

class EmployeeAddingState extends EmployeesState {}

class EmployeeAddedState extends EmployeesState {}

class EmployeeEditingState extends EmployeesState {}

class EmployeeEditedState extends EmployeesState {}

class EmployeesFormState extends EmployeesState {
  final String name;
  final String role;
  final DateTime startDate;
  final DateTime? endDate;

  EmployeesFormState({
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });
}

//State that show employee is deleted/updated etc.
class EmployeeOperationDoneState extends EmployeesState {}

class EmployeeOperationErrorState extends EmployeesState {
  final String? error;

  EmployeeOperationErrorState(this.error);
}
