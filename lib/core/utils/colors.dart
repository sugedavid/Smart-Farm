import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF5ACE5A);
  static const accentColor = Color.fromARGB(255, 237, 72, 72);
  static const lightColor = Color(0xFFFFFFFF);
  static const backgroundColor = Color(0xFFF5F5F5);

  static const darkModePimaryColor = Color(0xFFaae5a4);
  static const darkModeBackgroundColor = Color(0xFF121212);
  static const darkModeNavBarBackgroundColor = Color(0xFF3f3f3f);
  static const darkModeSurfaceColor = Color(0xFF282828);

  static Color fromHex(String hex) {
    final int value = int.parse(hex, radix: 16);
    return Color(value);
  }
}
