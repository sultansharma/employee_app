import 'package:employee_app/core/const.dart';
import 'package:employee_app/core/widgets/myToast.dart';
import 'package:employee_app/custom_date_picker/widgets/date_picker_helper.dart';
import 'package:employee_app/data/database/localstore.dart';
import 'package:employee_app/logic/cubits/employees_state.dart';
import 'package:employee_app/ui/widget/select_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:isar/isar.dart';

import '../../custom_date_picker/date_picker.dart';
import '../../data/models/employee.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit() : super(EmployeesLoadingState());
  //final db = DatabaseService.db;
  //DatabaseService database = DatabaseService(); // Access the Hive box
  Employee? _recentlyDeletedEmployee;
  String? editingId; //Only For desktop

  getEmployees() async {
    // emit(EmployeesLoadingState());
    try {
      List<Employee> employees = await DatabaseService.getAllEmployees();
      emit(EmployeesLoadedState(employees));
    } catch (e) {
      emit(EmployeesErrorState('Error loading employees: $e'));
    }
  }

  Future<Employee?> addEmployee() async {
    if (validateInputs()) {
      final employee = Employee(
          name: empNameController.text,
          role: roleController.text,
          startDate: startDate,
          endDate: endDate);
      try {
        await DatabaseService.saveEmployee(employee);
        emit(EmployeeOperationAddedState());
        await getEmployees();
      } catch (e) {
        emit(EmployeeOperationErrorState('Error updating employee: $e'));
      }
      return employee;
    } else {
      await getEmployees();
      return null;
    }
  }

  Future<bool> updateEmployee(String id) async {
    editingId = id; //Only for desktop
    if (validateInputs()) {
      try {
        final employee = await DatabaseService.getEmployee(id);
        if (employee != null) {
          employee.id = id;
          employee.name = empNameController.text;
          employee.role = roleController.text;
          employee.startDate = startDate;
          employee.endDate = endDate;
          await DatabaseService.saveEmployee(employee);
        }
        emit(EmployeeOperationUpdatedState());
        await getEmployees();
        return true;
      } catch (e) {
        emit(EmployeeOperationErrorState('Error updating employee: $e'));
        return false;
      }
    }
    await getEmployees();
    return false;
  }

  Future<void> deleteEmployee(String id) async {
    try {
      _recentlyDeletedEmployee = await DatabaseService.getEmployee(id);
      await DatabaseService.deleteEmployee(id);
      emit(EmployeeDeletedState());
      await getEmployees();
      if (editingId == id) {
        editingId = null;
        resetForm();
      }
    } catch (e) {
      emit(EmployeeOperationErrorState('Error deleting employees: $e'));
    }
  }

  void undoDelete() async {
    if (_recentlyDeletedEmployee != null) {
      onEditTapped(_recentlyDeletedEmployee!);
      addEmployee();
      _recentlyDeletedEmployee = null;
      await getEmployees(); // Clear the temporary storage
    }
  }

  //Edit functions like select date

  TextEditingController empNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  late DateTime startDate;
  DateTime? endDate;

  void onEditTapped(Employee employee) {
    editingId = employee.id;
    empNameController.text = employee.name;
    roleController.text = employee.role;
    startDate = employee.startDate;
    endDate = employee.endDate;
    startDateController.text = DatePickerHelper.formatDate(employee.startDate);
    endDateController.text = DatePickerHelper.formatDate(employee.endDate);
  }

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
      emit(EmployeeOperationErrorState(AppStrings.endDateShouldOlder));
      //myToast(context, text: "End date can't be before Start date");
    }
  }

  void onRoleSelected(BuildContext context) async {
    var role = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (context) => SelectRole(),
    );
    if (role != null) roleController.text = role;
  }

  void resetForm() {
    editingId = null;
    empNameController.clear();
    roleController.clear();
    startDateController.clear();
    endDateController.clear();
    startDate = DateTime.now(); // Default to current date or some initial value
    endDate = null;
  }

  //Validations

  bool validateInputs() {
    // Check if the fields are empty
    if (empNameController.text.isEmpty ||
        roleController.text.isEmpty ||
        startDateController.text.isEmpty) {
      emit(EmployeeOperationErrorState(AppStrings.fillAll));

      return false;
    }

    // Validate name: only alphanumeric (letters and numbers)
    String trimmedName = empNameController.text.trim();

    if (!RegExp(r'^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$').hasMatch(trimmedName)) {
      emit(EmployeeOperationErrorState(AppStrings.correctName));
      return false;
    }

    // You can also add a check for the role if needed (optional)
    if (roleController.text.isEmpty) {
      emit(EmployeeOperationErrorState(AppStrings.selectRole));
      return false;
    }

    return true; // Everything is valid
  }
}
