import 'package:employee_app/core/widgets/addaptiveText.dart';
import 'package:employee_app/ui/table_desktop_ui/desktop_add_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_app/data/models/employee.dart';
import 'package:employee_app/ui/widget/emplyee_header.dart';
import 'package:employee_app/logic/cubits/employees_cubit.dart';
import 'package:employee_app/logic/cubits/employees_state.dart';
import 'package:employee_app/ui/widget/employee_card.dart';
import 'package:employee_app/core/const.dart';
import 'package:employee_app/core/widgets/myToast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesktopUi extends StatefulWidget {
  const DesktopUi({super.key});

  @override
  State<DesktopUi> createState() => _DesktopUiState();
}

class _DesktopUiState extends State<DesktopUi> {
  Employee? _selectedEmployee;
  bool _addEmployee = false;

  void _selectEditEmployee(Employee employee) {
    context.read<EmployeesCubit>().onEditTapped(employee);
    setState(() {
      _selectedEmployee = employee;
      _addEmployee = false;
    });
  }

  void _selectAddEmployee() {
    context.read<EmployeesCubit>().resetForm();
    context.read<EmployeesCubit>().editingId = null;
    setState(() {
      _addEmployee = !_addEmployee;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEmployee = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmployeesCubit>();

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: adaptiveText(context)),
        title: const Text('Employee List'),
      ),
      body: Row(
        children: [
          // Left Panel: Employee List
          Expanded(
            flex: 2,
            child: BlocConsumer<EmployeesCubit, EmployeesState>(
              listener: (context, state) {
                if (state is EmployeeOperationUpdatedState) {
                  myToast(context,
                      type: 'done', text: 'Employee data has been updated.');
                }
                if (state is EmployeeOperationAddedState) {
                  myToast(context,
                      type: 'done', text: 'Employee data has been added.');
                  cubit.resetForm();
                }

                if (state is EmployeeDeletedState) {
                  myToast(context,
                      text: 'Employee data has been deleted',
                      undo: true, onPressed: () {
                    context.read<EmployeesCubit>().undoDelete();
                  });
                }
              },
              builder: (context, state) {
                if (state is EmployeesLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is EmployeesErrorState) {
                  return Center(child: Text(state.error));
                }

                if (state is EmployeesLoadedState) {
                  final currentEmployee = state.employees
                      .where((e) =>
                          e.endDate == null ||
                          e.endDate!.isAfter(DateTime.now()))
                      .toList();
                  final previousEmployee = state.employees
                      .where((e) =>
                          e.endDate != null &&
                          e.endDate!.isBefore(DateTime.now()))
                      .toList();

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            //height: MediaQuery.of(context).size.height-100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (currentEmployee.isEmpty &&
                                    previousEmployee.isEmpty)
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: MediaQuery.sizeOf(context).height,
                                    child: Center(
                                      child: Image.asset(
                                        AppAssets.noEmployee,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                if (currentEmployee.isNotEmpty) ...[
                                  header(context, AppStrings.curEmployees),
                                  ListView.separated(
                                    primary: false,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: currentEmployee.length,
                                    separatorBuilder: (_, __) => Divider(
                                        height: 0, color: Colors.grey.shade200),
                                    itemBuilder: (_, int index) {
                                      final employee = currentEmployee[index];

                                      return EmployeeCard(
                                        employee: employee,
                                        bgColor: cubit.editingId != employee.id
                                            ? Colors.grey.shade50
                                            : null,
                                        onEdit: () {
                                          _selectEditEmployee(employee);
                                        },
                                        onDelete: () async {
                                          await context
                                              .read<EmployeesCubit>()
                                              .deleteEmployee(
                                                  employee.id.toString());
                                        },
                                      );
                                    },
                                  ),
                                ],
                                if (previousEmployee.isNotEmpty) ...[
                                  header(context, AppStrings.prevEmployees),
                                  ListView.separated(
                                    primary: false,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: previousEmployee.length,
                                    separatorBuilder: (_, __) => Divider(
                                        height: 0, color: Colors.grey.shade200),
                                    itemBuilder: (_, int index) {
                                      final employee = previousEmployee[index];

                                      return EmployeeCard(
                                        employee: employee,
                                        bgColor: cubit.editingId != employee.id
                                            ? Colors.grey.shade50
                                            : null,
                                        onEdit: () {
                                          _selectEditEmployee(employee);
                                        },
                                        onDelete: () {
                                          context
                                              .read<EmployeesCubit>()
                                              .deleteEmployee(
                                                  employee.id.toString());
                                        },
                                      );
                                    },
                                  ),
                                ],
                                if (state.employees.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(AppStrings.toDelete,
                                        style: TextStyle(
                                            color: Colors
                                                .grey)), // Adds the message
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            onPressed: () => _selectAddEmployee(),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            child: Icon(_addEmployee && cubit.editingId == null
                                ? Icons.remove
                                : Icons.add),
                          ),
                        )
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          // Right Panel: Employee Form
          if (cubit.editingId != null || _addEmployee) ...[
            Expanded(
              flex: 2,
              child: DesktopAddEdit(employee: _selectedEmployee),
            ),
          ] else ...[
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Select an employee to edit or add a new one.',
                  style: TextStyle(color: AppColors.subTitle),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
