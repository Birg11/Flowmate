import 'dart:ui';

enum Season { spring, summer, autumn, winter }

class SeasonalColors {
  static const spring = [Color(0xFFE2F4C5), Color(0xFFF8D5EC)];
  static const summer = [Color(0xFFFFD166), Color(0xFFF67280)];
  static const autumn = [Color(0xFFD4A373), Color(0xFFFFB5A7)];
  static const winter = [Color(0xFFA2D2FF), Color(0xFFBDB2FF)];

  static List<Color> bySeason(Season season) {
    switch (season) {
      case Season.spring:
        return spring;
      case Season.summer:
        return summer;
      case Season.autumn:
        return autumn;
      case Season.winter:
        return winter;
    }
  }
}
