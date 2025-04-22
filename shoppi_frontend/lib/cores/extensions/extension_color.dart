import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    // final buffer = StringBuffer();
    // if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    // buffer.write(hexString.replaceFirst('#', ''));
    // return Color(int.parse(buffer.toString(), radix: 16));
    if (hexString.isEmpty) {
      return Colors.black;
    }
    if (hexString.length == 9 &&
        hexString.substring(0, 2).toLowerCase() != 'ff') {
      String opacity = hexString.substring(7, 9);
      String color = hexString.substring(1, 7);
      return Color(int.parse('$opacity$color', radix: 16));
    }
    return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}'
      '${alpha.toRadixString(16).padLeft(2, '0')}';
}
