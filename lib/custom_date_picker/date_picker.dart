import 'package:employee_app/core/const.dart';
import 'package:employee_app/core/widgets/hexColor.dart';
import 'package:employee_app/custom_date_picker/widgets/date_selecter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../logic/cubits/employees_cubit.dart';

class DateSelectorDialoge extends StatefulWidget {
  final bool isStartDate;
  final DateTime? selectedStartDate;
  const DateSelectorDialoge(
      {super.key, required this.isStartDate, this.selectedStartDate});

  @override
  State<DateSelectorDialoge> createState() => _DateSelectorDialogeState();
}

class _DateSelectorDialogeState extends State<DateSelectorDialoge> {
  DateTime focusedDate = DateTime.now();
  DateTime? chosenDate = DateTime.now();

  bool todaySelected = false;
  bool nextMondaySelected = false;
  bool nextTuesdaySelected = false;
  bool weekLaterSelected = false;
  bool noDateSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isStartDate) {
      setState(() {
        chosenDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    todaySelected = isSameDay(chosenDate, DateTime.now());
    nextMondaySelected =
        isSameDay(chosenDate, DatePickerHelper.fetchNextMonday());
    nextTuesdaySelected =
        isSameDay(chosenDate, DatePickerHelper.fetchNextTuesday());
    weekLaterSelected =
        isSameDay(chosenDate, DatePickerHelper.getWeekAheadDate());

    noDateSelected = chosenDate == null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.verticalSpace,
            widget.isStartDate ? startDateOptions() : endDateOptions(),
            calendarView(context),
            16.verticalSpace,
            footerSection(context)
          ],
        ),
      ),
    );
  }

  Widget startDateOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _button(
                selected: todaySelected,
                text: 'Today',
                onPressed: () {
                  setState(() {
                    chosenDate = DateTime.now();
                    focusedDate = DateTime.now();
                  });
                },
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _button(
                selected: nextMondaySelected,
                text: 'Next Monday',
                onPressed: () {
                  setState(() {
                    chosenDate = DatePickerHelper.fetchNextMonday();
                    focusedDate = DatePickerHelper.fetchNextMonday();
                  });
                },
              ),
            ),
          ],
        ),
        8.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _button(
                selected: nextTuesdaySelected,
                text: 'Next Tuesday',
                onPressed: () {
                  setState(() {
                    chosenDate = DatePickerHelper.fetchNextTuesday();
                    focusedDate = DatePickerHelper.fetchNextTuesday();
                  });
                },
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _button(
                selected: weekLaterSelected,
                text: 'After 1 Week',
                onPressed: () {
                  setState(() {
                    chosenDate = DatePickerHelper.getWeekAheadDate();
                    focusedDate = DatePickerHelper.getWeekAheadDate();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget endDateOptions() {
    return Row(
      children: [
        Expanded(
          child: _button(
            selected: noDateSelected,
            text: 'No Date',
            onPressed: () {
              setState(() {
                chosenDate = null;
                focusedDate = DateTime.now();
              });
            },
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: _button(
            selected: todaySelected,
            text: 'Today',
            onPressed: () {
              setState(() {
                chosenDate = DateTime.now();
                focusedDate = DateTime.now();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget calendarView(BuildContext context) {
    return TableCalendar(
        focusedDay: focusedDate,
        firstDay: DateTime(2010, 1, 1),
        lastDay: DateTime(2030, 12, 31),
        selectedDayPredicate: (day) => isSameDay(chosenDate, day),
        onDaySelected: (selected, focused) {
          setState(() {
            chosenDate = selected;
            focusedDate = focused;
          });
        },
        enabledDayPredicate: (date) {
          if (widget.isStartDate) {
            return true;
          } else {
            return widget.selectedStartDate != null
                ? date.isAfter(
                    widget.selectedStartDate!.subtract(Duration(days: 1)))
                : false;
          }
        },
        rangeStartDay: chosenDate ?? focusedDate,
        onHeaderTapped: (focused) async {
          final selectedDate = await showDatePicker(
            context: context,
            firstDate: DateTime(2010, 1, 1),
            lastDate: DateTime(2030, 12, 31),
            initialDatePickerMode: DatePickerMode.year,
          );
          if (selectedDate != null) {
            setState(() {
              focusedDate = selectedDate;
              chosenDate = selectedDate;
            });
          }
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: AppColors.primary),
          todayDecoration: !widget.isStartDate
              ? BoxDecoration(
                  shape: BoxShape.circle,
                )
              : BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  shape: BoxShape.circle,
                ),
          weekendTextStyle: TextStyle(),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          headerPadding: EdgeInsets.symmetric(
            horizontal: 70,
          ),
          headerMargin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          leftChevronMargin: EdgeInsets.zero,
          rightChevronMargin: EdgeInsets.zero,
          leftChevronPadding: EdgeInsets.zero,
          rightChevronPadding: EdgeInsets.zero,
          leftChevronIcon: SvgPicture.asset(AppAssets.arrowPrevIcon),
          rightChevronIcon: SvgPicture.asset(AppAssets.arrowNextIcon),
        ));
  }

  Widget footerSection(BuildContext context) {
    return Column(
      children: [
        Divider(height: 2, thickness: 2, color: AppColors.border),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppAssets.calendarIcon),
                  4.horizontalSpace,
                  Text(DatePickerHelper.formatDate(chosenDate)),
                ],
              ),
              Row(
                children: [
                  _button(
                    selected: false,
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  8.horizontalSpace,
                  _button(
                    selected: true,
                    text: 'Save',
                    onPressed: () {
                      Navigator.pop(context, chosenDate);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _button({dynamic onPressed, String? text, bool selected = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppColors.primary : AppColors.lightBlue,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
        ),
      ),
      child: Text(
        text.toString(),
        style: TextStyle(
            fontSize: 12, color: selected ? Colors.white : AppColors.primary),
      ),
    );
  }
}
