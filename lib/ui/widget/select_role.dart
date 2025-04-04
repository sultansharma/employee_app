import 'package:employee_app/core/const.dart';
import 'package:flutter/material.dart';

class SelectRole extends StatelessWidget {
  SelectRole({super.key});

  final List<String> roles = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        roles.length,
        (index) => Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context, roles[index]);
              },
              contentPadding: EdgeInsets.zero,
              minTileHeight: 0,
              minVerticalPadding: 16,
              title: Center(
                child: Text(
                  roles[index],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.selectRoleColor),
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.bgGrey,
            )
          ],
        ),
      ),
    );
  }
}
