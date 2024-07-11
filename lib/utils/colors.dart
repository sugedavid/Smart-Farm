import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_farm/utils/shared_prefs.dart';

class AppColors {
  static const primaryColor = Color(0xFF5ACE5A);
  static const accentColor = Color.fromARGB(255, 237, 72, 72);
  static const lightColor = Color(0xFFFFFFFF);
  static const darkColor = Color(0xFF000000);
  static const backgroundColor = Color(0xFFF5F5F5);

  static Color fromHex(String hex) {
    final int value = int.parse(hex, radix: 16);
    return Color(value);
  }

  void setDarkMode() async {
    StorageManager.saveData('themeMode', 'dark');
  }

  void setLightMode() async {
    StorageManager.saveData('themeMode', 'light');
  }
}
