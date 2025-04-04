import 'package:employee_app/core/const.dart';
import 'package:employee_app/core/widgets/myToast.dart';
import 'package:employee_app/core/widgets/inputDecoration.dart';
import 'package:employee_app/data/models/employee.dart';
import 'package:employee_app/logic/cubits/employees_cubit.dart';
import 'package:employee_app/logic/cubits/employees_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DesktopAddEdit extends StatefulWidget {
  const DesktopAddEdit({
    super.key,
    this.employee,
  });

  final Employee? employee;

  @override
  State<DesktopAddEdit> createState() => _DesktopAddEditState();
}

class _DesktopAddEditState extends State<DesktopAddEdit> {
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

    if (context.read<EmployeesCubit>().editingId != null) {
      await context
          .read<EmployeesCubit>()
          .updateEmployee(widget.employee!.id.toString());
    } else {
      await context.read<EmployeesCubit>().addEmployee();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeesCubit, EmployeesState>(
      listener: (context, state) {
        if (state is EmployeeOperationErrorState) {
          myToast(context, text: state.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<EmployeesCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            toolbarHeight: 48,
            backgroundColor: AppColors.border,
            automaticallyImplyLeading: false,
            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 15),
            title: Text(cubit.editingId != null
                ? 'Edit Employee Details'
                : 'Add Employee'),
            actions: cubit.editingId != null && _isEditing
                ? [
                    IconButton(
                      onPressed: () async {
                        await cubit.deleteEmployee(widget.employee!.id!);
                      },
                      icon: SvgPicture.asset(
                        AppAssets.removeIcon,
                        color: Colors.red,
                      ),
                    ),
                  ]
                : null,
          ),
          body: _buildFormBody(context, cubit),
        );
      },
    );
  }

  Widget _buildFormBody(BuildContext context, EmployeesCubit cubit) {
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
                            decoration: inputDecoration(AppAssets.calendarIcon)
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
                            decoration: inputDecoration(AppAssets.calendarIcon)
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
    );
  }
}
