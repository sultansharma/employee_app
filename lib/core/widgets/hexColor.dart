import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  // Remove the '#' prefix if it exists
  hexString = hexString.replaceAll("#", "");

  // Handle cases where the alpha value is included (e.g., #RRGGBBAA)
  if (hexString.length == 8) {
    return Color(int.parse(hexString, radix: 16));
  } else if (hexString.length == 6) {
    // If no alpha value, assume full opacity (FF)
    return Color(int.parse("FF" + hexString, radix: 16));
  } else {
    throw ArgumentError("Invalid HEX string format");
  }
}
