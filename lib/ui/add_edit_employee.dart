import 'package:employee_app/core/widgets/myToast.dart';
import 'package:employee_app/core/widgets/inputDecoration.dart';
import 'package:employee_app/custom_date_picker/widgets/date_selecter.dart';
import 'package:employee_app/data/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../core/const.dart';
import '../logic/cubits/employees_cubit.dart';

class AddEditEmployee extends StatefulWidget {
  const AddEditEmployee({
    super.key,
    this.employee,
  });

  final Employee? employee;

  @override
  State<AddEditEmployee> createState() => _AddEditEmployeeState();
}

class _AddEditEmployeeState extends State<AddEditEmployee> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  // final TextEditingController _roleController = TextEditingController();
  // DateTime? _startDate;
  // DateTime? _endDate;

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    final employee = widget.employee;

    if (employee != null) {
      _nameController.text = employee.name ?? "";
      // _roleController.text = employee.role ?? "";
      // _startDate = employee.startDate;
      // _endDate = employee.endDate;
    }
  }

  void _showRoleBottomSheet(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<EmployeesCubit>().onRoleSelected(context);
  }

  void _selectStartDate() {
    context
        .read<EmployeesCubit>()
        .onDateWidgetTapped(context, isStartDate: true);
  }

  _selectEndDate() {
    context
        .read<EmployeesCubit>()
        .onDateWidgetTapped(context, isStartDate: false);
  }

  void _onSave() async {
    final employee =
        await context.read<EmployeesCubit>().addEmployee(_nameController.text);
    Navigator.of(context).pop(employee);
  }

  // void _onSave() {
  //   FocusScope.of(context).unfocus();

  //   if (!_formKey.currentState!.validate()) return;

  //   final role = _roleController.text;

  //   if (role.isEmpty) {
  //     myToast(context, text: 'Please select a role');
  //     return;
  //   }

  //   if (_startDate == null) {
  //     myToast(context, text: 'Please select start date');

  //     return;
  //   }

  //   final employee = Employee(
  //     name: _nameController.text,
  //     role: role,
  //     startDate: _startDate!,
  //     endDate: _endDate,
  //   );

  //   if (_isEditing) {
  //     context.read<EmployeesCubit>().updateEmployee(employee.id, employee.name,
  //         employee.role, employee.startDate, employee.endDate);
  //   } else {
  //     context.read<EmployeesCubit>().addEmployee(employee);
  //   }

  //   Navigator.of(context).pop(employee);
  // }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmployeesCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        // iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        title: Text('${_isEditing ? 'Edit' : 'Add'} Employee Details'),
        actions: [
          if (_isEditing) ...[
            IconButton(
              onPressed: () => {cubit.deleteEmployee(0)},
              icon: const Icon(Icons.delete),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        decoration: inputDecoration(
                          AppAssets.employeeIcon,
                        ).copyWith(
                          hintText: 'Employee Name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showRoleBottomSheet(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: cubit.roleController,
                            decoration: inputDecoration(AppAssets.jobRoleIcon,
                                    sIcon: AppAssets.arrowDownIcon)
                                .copyWith(hintText: 'Select Role'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onTap: _selectStartDate,
                              readOnly: true,
                              style: const TextStyle(fontSize: 14),
                              controller: cubit.startDateController,
                              decoration:
                                  inputDecoration(AppAssets.calendarIcon)
                                      .copyWith(hintText: 'No Date'),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          SvgPicture.asset(
                            AppAssets.arrowRightIcon,
                            color: AppColors.primary,
                            height: 14,
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              onTap: _selectEndDate,
                              readOnly: true,
                              controller: cubit.endDateController,
                              style: const TextStyle(fontSize: 14),
                              decoration:
                                  inputDecoration(AppAssets.calendarIcon)
                                      .copyWith(hintText: 'No Date'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: AppColors.border,
            thickness: 2,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.lightBlue,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF1DA1F2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    onPressed: _onSave,
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
