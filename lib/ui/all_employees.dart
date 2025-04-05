import 'package:employee_app/core/const.dart';
import 'package:employee_app/core/widgets/addaptiveText.dart';
import 'package:employee_app/core/widgets/myToast.dart';
import 'package:employee_app/custom_date_picker/date_picker.dart';
import 'package:employee_app/data/models/employee.dart';
import 'package:employee_app/logic/cubits/employees_state.dart';
import 'package:employee_app/ui/add_edit_employee.dart';
import 'package:employee_app/ui/widget/emplyee_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cubits/employees_cubit.dart';
import 'widget/employee_card.dart';

class AllEmployees extends StatelessWidget {
  const AllEmployees({super.key});

  void _openEmployeeFormScreen(BuildContext context,
      {Employee? employee}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<EmployeesCubit>(),
          child: AddEditEmployee(
            employee: employee,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: adaptiveText(
              context,
              extra: 4,
            )),
        title: const Text('Employee List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEmployeeFormScreen(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: adaptiveSp(context, factor: 1.5),
        ),
      ),
      body: BlocConsumer<EmployeesCubit, EmployeesState>(
        listener: (context, state) {
          if (state is EmployeeOperationUpdatedState) {
            myToast(context,
                type: 'done', text: 'Employee data has been updated.');
          }
          if (state is EmployeeOperationAddedState) {
            myToast(context,
                type: 'done', text: 'Employee data has been added.');
          }

          if (state is EmployeeDeletedState) {
            myToast(
              context,
              text: 'Employee data has been deleted',
              undo: true,
              onPressed: () {
                context.read<EmployeesCubit>().undoDelete();
              },
            );
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
                    e.endDate == null || e.endDate!.isAfter(DateTime.now()))
                .toList();
            final previousEmployee = state.employees
                .where((e) =>
                    e.endDate != null && e.endDate!.isBefore(DateTime.now()))
                .toList();

            if (currentEmployee.isEmpty && previousEmployee.isEmpty) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: Image.asset(
                    AppAssets.noEmployee,
                    height: 200,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentEmployee.isNotEmpty) ...[
                    header(context, AppStrings.curEmployees),
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: currentEmployee.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 0, color: Colors.grey.shade200),
                      itemBuilder: (_, int index) {
                        final employee = currentEmployee[index];

                        return EmployeeCard(
                          employee: employee,
                          onEdit: () {
                            context
                                .read<EmployeesCubit>()
                                .onEditTapped(employee);
                            _openEmployeeFormScreen(context,
                                employee: employee);
                          },
                          onDelete: () async {
                            await context
                                .read<EmployeesCubit>()
                                .deleteEmployee(employee.id.toString());
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
                      separatorBuilder: (_, __) =>
                          Divider(height: 0, color: Colors.grey.shade200),
                      itemBuilder: (_, int index) {
                        final employee = previousEmployee[index];

                        return EmployeeCard(
                          employee: employee,
                          onEdit: () {
                            context
                                .read<EmployeesCubit>()
                                .onEditTapped(employee);
                            _openEmployeeFormScreen(context,
                                employee: employee);
                          },
                          onDelete: () {
                            context
                                .read<EmployeesCubit>()
                                .deleteEmployee(employee.id.toString());
                          },
                        );
                      },
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Swipe left to delete',
                        style:
                            TextStyle(color: Colors.grey)), // Adds the message
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
