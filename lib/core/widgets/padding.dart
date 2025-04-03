import 'package:flutter/material.dart';

Widget paddingAll(double padding, Widget widget) =>
    Padding(padding: EdgeInsets.all(padding), child: widget);

Widget paddingSymmetric(
        {double horizontal = 0.0, double vertical = 0.0, Widget? widget}) =>
    Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: widget);

Widget paddingOnly(
        {double left = 0.0,
        double top = 0.0,
        double right = 0.0,
        double bottom = 0.0,
        Widget? widget}) =>
    Padding(
        padding:
            EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
        child: widget);
