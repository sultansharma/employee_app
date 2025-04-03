import 'package:employee_app/core/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

InputDecoration inputDecoration(String icon, {String? sIcon}) {
  return InputDecoration(
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: SizedBox(
          height: 20,
          width: 20,
          child: Center(
            child: SvgPicture.asset(
              icon,
              color: AppColors.primary,
              height: 20,
            ),
          ),
        ),
      ),
      suffixIcon: sIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: SvgPicture.asset(
                    sIcon, // Corrected variable reference
                    color: AppColors.primary,
                    height: 20,
                  ),
                ),
              ),
            )
          : null, // Properly handle optional suffix icon

      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.border, // Default border color when not focused
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.border, // Border color when the field is focused
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.border, // Border color when enabled but not focused
        ),
        borderRadius: BorderRadius.circular(6),
      ));
}
