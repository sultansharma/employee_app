import 'package:employee_app/core/widgets/addaptiveText.dart';
import 'package:employee_app/core/widgets/myToast.dart';
import 'package:employee_app/core/widgets/inputDecoration.dart';
import 'package:employee_app/data/models/employee.dart';
import 'package:employee_app/logic/cubits/employees_state.dart';
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

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    if (!_isEditing) {
      context
          .read<EmployeesCubit>()
          .resetForm(); // Reset only for adding a new employee
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
    if (!mounted) return;

    if (_isEditing) {
      final employee = await context
          .read<EmployeesCubit>()
          .updateEmployee(widget.employee!.id.toString());

      if (mounted && employee) {
        Navigator.of(context).pop();
      }
    } else {
      final employee = await context.read<EmployeesCubit>().addEmployee();

      if (mounted && employee != null) {
        Navigator.of(context).pop(employee);
      }
    }
  }

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
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: adaptiveText(
              context,
              extra: 4,
            )),
        title: Text('${_isEditing ? 'Edit' : 'Add'} Employee Details'),
        actions: [
          if (_isEditing) ...[
            IconButton(
              onPressed: () async {
                await cubit.deleteEmployee(widget.employee!.id.toString());
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset(AppAssets.removeIcon),
            ),
          ],
        ],
      ),
      body: BlocConsumer<EmployeesCubit, EmployeesState>(
          listener: (context, state) {
        if (state is EmployeeOperationErrorState) {
          myToast(context, text: state.error);
        }
      }, builder: (context, state) {
        return Column(
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
                          controller: cubit.empNameController,
                          style: TextStyle(fontSize: adaptiveText(context)),
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
                              style: TextStyle(fontSize: adaptiveText(context)),
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
                                style:
                                    TextStyle(fontSize: adaptiveText(context)),
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
                                style:
                                    TextStyle(fontSize: adaptiveText(context)),
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
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: adaptiveText(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: _onSave,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: adaptiveText(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
