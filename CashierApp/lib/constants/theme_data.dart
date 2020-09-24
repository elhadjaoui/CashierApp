import 'dart:math';

import 'package:flutter/material.dart';

class CustomColors {
  static int gradientIndex()
  {
    var randomIndex = Random();
    return  randomIndex.nextInt(GradientTemplate.gradientTemplate.length - 1);
  }

  static List<Color> gradientColor =
      GradientTemplate.gradientTemplate[gradientIndex()].colors;
  static Color primaryTextColor = Colors.white;
  static Color dividerColor = Colors.white54;
  static Color pageBackgroundColor = Color(0xFF2D2F41);
  static Color menuBackgroundColor = Color(0xFF242634);

  static Color clockBG = Color(0xFF34495E );
  static Color clockOutline = Color(0xFFEAECFF);
  static Color secHandColor = Colors.orange[300];
  static Color minHandStatColor = Color(0xFF748EF6);
  static Color minHandEndColor = Color(0xFF77DDFF);
  static Color hourHandStatColor = Color(0xFFC279FB);
  static Color hourHandEndColor = Color(0xFFEA74AB);
}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
  static List<Color> fire1 = [Color(0xFFFFA738), Color(0xFF61A3FE)];
  static List<Color> fire2 = [Color(0xFFFF5DCD), Color(0xFFFFA738)];
  static List<Color> fire3 = [Color(0xFF6448FE), Color(0xFFFF8484)];
  static List<Color> fire4 = [Color(0xFF63FFD5), Color(0xFFFF8484)];
  static List<Color> fire5 = [Color(0xFF61A3FE), Color(0xFFFFB463)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
//    GradientColors(GradientColors.fire3),
//    GradientColors(GradientColors.fire1),
//    GradientColors(GradientColors.fire2),
//    GradientColors(GradientColors.fire4),
//    GradientColors(GradientColors.fire5)
  ];
}
