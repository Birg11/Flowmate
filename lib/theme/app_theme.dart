import 'package:flutter/material.dart';

enum FlowThemeMode { light, dark, seasonal }

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFFBDB2FF),
        secondary: const Color(0xFFF67280),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
    );
  }

 static ThemeData dark() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    colorScheme: const ColorScheme.dark(
      primary: Colors.purpleAccent,
      secondary: Colors.pinkAccent,
    ),
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}

static ThemeData seasonalLight() {
  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color(0xFFF8D5EC),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE2F4C5),
      secondary: Color(0xFFF8D5EC),
    ),
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
    ),
  );
}

}
