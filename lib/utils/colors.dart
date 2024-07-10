import 'dart:ui';

class AppColors {
  static const primaryColor = Color(0xFF32CD32);
  static const accentColor = Color.fromARGB(255, 237, 72, 72);
  static const lightColor = Color(0xFFFFFFFF);
  static const darkColor = Color(0xFF000000);
  static const backgroundColor = Color(0xFFF5F5F5);

  static Color fromHex(String hex) {
    final int value = int.parse(hex, radix: 16);
    return Color(value);
  }
}
