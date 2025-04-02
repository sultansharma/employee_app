import 'package:employee_app/custom_date_picker/widgets/date_picker_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';

class DayMonthPicker extends StatefulWidget {
  final Widget child;
  final Function onChange;
  final String? existingDay;
  final String? existingMonth;
  final Color? surfaceTintColor;
  final Color selectedMonthBgColor;
  final Color unSelectedMonthBgColor;
  final Color selectedDayBgColor;
  final Color unSelectedDayBgColor;
  final TextStyle? titleTextStyle;
  final TextStyle cancelTextStyle;
  final TextStyle okTextStyle;
  final String title;
  final TextStyle? selectedMonthTextStyle;
  final TextStyle? unSelectedMonthTextStyle;
  final TextStyle? selectedDayTextStyle;
  final TextStyle? unSelectedDayTextStyle;

  const DayMonthPicker(
      {super.key,
      this.surfaceTintColor,
      this.titleTextStyle,
      this.selectedMonthBgColor = Colors.blue,
      this.unSelectedMonthBgColor = Colors.white,
      this.selectedDayBgColor = Colors.blue,
      this.unSelectedDayBgColor = Colors.white,
      this.title = "Date Month Picker",
      this.selectedMonthTextStyle =
          const TextStyle(color: Colors.white, fontSize: 14),
      this.unSelectedMonthTextStyle =
          const TextStyle(color: Colors.black, fontSize: 14),
      this.selectedDayTextStyle =
          const TextStyle(color: Colors.white, fontSize: 12),
      this.unSelectedDayTextStyle =
          const TextStyle(color: Colors.black, fontSize: 12),
      this.child = const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Month Picker"),
      ),
      this.cancelTextStyle = const TextStyle(color: Colors.grey, fontSize: 16),
      this.okTextStyle = const TextStyle(color: Colors.blue, fontSize: 16),
      this.existingDay,
      this.existingMonth,
      required this.onChange});

  @override
  State<DayMonthPicker> createState() => _DayMonthPickerState();
}

class _DayMonthPickerState extends State<DayMonthPicker> {
  final Map<String, List<String>> monthDays = {
    "Jan": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
    "Feb": List<String>.generate(
        29, (index) => (index + 1).toString().padLeft(2, '0')),
    // Adjust based on leap year
    "Mar": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
    "Apr": List<String>.generate(
        30, (index) => (index + 1).toString().padLeft(2, '0')),
    "May": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
    "Jun": List<String>.generate(
        30, (index) => (index + 1).toString().padLeft(2, '0')),
    "Jul": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
    "Aug": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
    "Sep": List<String>.generate(
        30, (index) => (index + 1).toString().padLeft(2, '0')),
    "Oct": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
    "Nov": List<String>.generate(
        30, (index) => (index + 1).toString().padLeft(2, '0')),
    "Dec": List<String>.generate(
        31, (index) => (index + 1).toString().padLeft(2, '0')),
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        int monthIndex = 0;
        int? dayIndex;
        if (widget.existingDay != null) {
          dayIndex = int.parse(widget.existingDay!) - 1;
        }
        if (widget.existingMonth != null) {
          monthIndex = int.parse(widget.existingMonth!) - 1;
        }

        showDialog(
            context: context,
            builder: (_) {
              DateTime dialogSelectedDate = DateTime.now();

              void _incrementMonth(StateSetter dialogSetState) {
                dialogSetState(() {
                  dialogSelectedDate = DateTime(
                      dialogSelectedDate.year, dialogSelectedDate.month + 1);
                });
              }

              void _decrementMonth(StateSetter dialogSetState) {
                if (dialogSelectedDate.year > DateTime.now().year ||
                    (dialogSelectedDate.year == DateTime.now().year &&
                        dialogSelectedDate.month > DateTime.now().month)) {
                  dialogSetState(() {
                    dialogSelectedDate = DateTime(
                        dialogSelectedDate.year, dialogSelectedDate.month - 1);
                  });
                }
              }

              return StatefulBuilder(builder: (_, dialogState) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                    ),
                    surfaceTintColor:
                        widget.surfaceTintColor ?? Colors.transparent,
                    titlePadding: EdgeInsets.all(14),
                    title: Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.height < 400
                            ? null
                            : 300,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                      child: _button(() {
                                        // Handle "Today" logic
                                      }, "Today", true),
                                    ),
                                    const SizedBox(
                                        width: 12), // Spacing between buttons
                                    Expanded(
                                      child: _button(() {
                                        // Handle "Today" logic
                                      }, "Next Monday", true),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                      child: _button(() {
                                        // Handle "Today" logic
                                      }, "Next Tuesday", true),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _button(() {
                                        // Handle "Today" logic
                                      }, "After 1 week", true),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: ImageIcon(
                                      AssetImage("assets/icons/arrow_prev.png"),
                                      size: 12,
                                      color: hexToColor(
                                          (dialogSelectedDate.year >
                                                      DateTime.now().year ||
                                                  (dialogSelectedDate.year ==
                                                          DateTime.now().year &&
                                                      dialogSelectedDate.month >
                                                          DateTime.now().month))
                                              ? "#949C9E"
                                              : "#E5E5E5"),
                                    ),
                                    onPressed: (dialogSelectedDate.year >
                                                DateTime.now().year ||
                                            (dialogSelectedDate.year ==
                                                    DateTime.now().year &&
                                                dialogSelectedDate.month >
                                                    DateTime.now().month))
                                        ? () => _decrementMonth(dialogState)
                                        : null,
                                  ),
                                  Text(
                                    DateFormat("MMMM yyyy")
                                        .format(dialogSelectedDate),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    icon: ImageIcon(
                                      AssetImage("assets/icons/arrow_next.png"),
                                      size: 12,
                                      color: hexToColor("#949C9E"),
                                    ),
                                    onPressed: () =>
                                        _incrementMonth(dialogState),
                                  ),
                                ],
                              ),
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: List.generate(
                                  12,
                                  (index) => InkWell(
                                        onTap: () {
                                          if (index == 1 &&
                                              dayIndex != null &&
                                              dayIndex! > 28) {
                                            dialogState(() {
                                              monthIndex = index;
                                              dayIndex = null;
                                            });
                                          } else {
                                            dialogState(
                                                () => monthIndex = index);
                                          }
                                        },
                                        child: Container(
                                            width: 60,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8),
                                            decoration: BoxDecoration(
                                                color: monthIndex == index
                                                    ? widget
                                                        .selectedMonthBgColor
                                                    : widget
                                                        .unSelectedMonthBgColor,
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: const Color(
                                                        0xff808191))),
                                            child: Center(
                                              child: Text(
                                                  monthDays.keys
                                                      .elementAt(index),
                                                  style: monthIndex == index
                                                      ? widget
                                                          .selectedMonthTextStyle
                                                      : widget
                                                          .unSelectedMonthTextStyle),
                                            )),
                                      )),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(height: 0.1, color: Colors.grey),
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: List.generate(
                                  monthDays.entries
                                      .elementAt(monthIndex)
                                      .value
                                      .length,
                                  (index) => InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () =>
                                            dialogState(() => dayIndex = index),
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: dayIndex == index
                                                  ? widget.selectedDayBgColor
                                                  : widget.unSelectedDayBgColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                                monthDays.entries
                                                    .elementAt(monthIndex)
                                                    .value[index]
                                                    .toString(),
                                                style: dayIndex == index
                                                    ? widget
                                                        .selectedDayTextStyle
                                                    : widget
                                                        .unSelectedDayTextStyle)),
                                      )),
                            ),
                            const SizedBox(height: 12.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text("Cancel",
                                            style: widget.cancelTextStyle),
                                      )),
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        DayMonth dayMonthData = DayMonth();
                                        if (dayIndex != null) {
                                          dayMonthData.day = (dayIndex! + 1)
                                              .toString()
                                              .padLeft(2, "0");
                                          dayMonthData.month = (monthIndex + 1)
                                              .toString()
                                              .padLeft(2, "0");
                                        }
                                        if (dayMonthData.day != null) {
                                          Navigator.of(context)
                                              .pop(dayMonthData);
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Ok",
                                          style: widget.okTextStyle,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              });
            }).then((dayMonth) => widget.onChange(dayMonth));
      },
      child: widget.child,
    );
  }

  Widget _button(dynamic onPressed, String text, bool selected) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: hexToColor("#EDF8FF"),
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
        ),
        // side: const BorderSide(
        //   color: Colors.grey,
        // ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: hexToColor("#1DA1F2")),
      ),
    );
  }
}
