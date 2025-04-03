import 'package:employee_app/core/widgets/myToast.dart';
import 'package:employee_app/custom_date_picker/widgets/date_selecter.dart';
import 'package:employee_app/data/database/isar.dart';

import 'package:employee_app/logic/cubits/employees_state.dart';
import 'package:employee_app/ui/widget/select_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../custom_date_picker/widgets/date_picker_widget.dart';
import '../../data/models/employee.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit() : super(EmployeesLoadingState());
  final db = DatabaseService.db;

  getEmployees() async {
    try {
      List<Employee> employees = await db.employees.where().findAll();
      emit(EmployeesLoadedState(employees));
    } catch (e) {
      emit(EmployeesErrorState('Error loading employees: $e'));
    }
  }

  Future<Employee> addEmployee(String name) async {
    final employee = Employee(
        name: name,
        role: roleController.text,
        startDate: startDate,
        endDate: endDate);
    try {
      db.writeTxn(() async => await db.employees.put(employee));
      emit(EmployeeOperationDoneState());
      getEmployees();
    } catch (e) {
      emit(EmployeeOperationErrorState('Error updating employee: $e'));
    }
    return employee;
  }

  Future<void> updateEmployee(int id, String name, String role,
      DateTime starDate, DateTime? endDate) async {
    try {
      final employee = await db.employees.get(id);
      if (employee != null) {
        employee.name = name;
        employee.role = role;
        employee.startDate = starDate;
        employee.endDate = endDate;
        await db.writeTxn(() async {
          await db.employees.put(employee);
        });
      }
      emit(EmployeeOperationDoneState());
    } catch (e) {
      emit(EmployeeOperationErrorState('Error updating employee: $e'));
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      db.writeTxn<bool>(() async => await db.employees.delete(id));
    } catch (e) {
      emit(EmployeeOperationErrorState('Error deleting employees: $e'));
    }
  }

  //Edit functions like select date

  TextEditingController empNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  late DateTime startDate;
  DateTime? endDate;

  void onDateWidgetTapped(BuildContext context,
      {required bool isStartDate}) async {
    if (!isStartDate && startDateController.text.isEmpty) {
      myToast(context, text: "Please select start date first!");
      return;
    }
    final selectedDate = await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DateSelectorDialoge(
        isStartDate: isStartDate,
        selectedStartDate: !isStartDate ? startDate : null,
      ),
    );

    if (selectedDate == null) {
      if (!isStartDate) {
        endDate = null;
        endDateController.clear();
      }
      return;
    }
    if (isStartDate) {
      startDate = selectedDate;
      startDateController.text = DatePickerHelper.formatDate(startDate);
    } else if (selectedDate.isAfter(startDate.subtract(Duration(hours: 1)))) {
      endDate = selectedDate;
      endDateController.text = DatePickerHelper.formatDate(endDate);
    } else {
      myToast(context, text: "End date can't be before Start date");
    }
  }

  void onRoleSelected(BuildContext context) async {
    var role = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (context) => SelectRole(),
    );
    if (role != null) roleController.text = role;
  }
}
