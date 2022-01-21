import 'package:flutter/material.dart';
import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/Themes/app_fonts.dart';

abstract class AppThemes {
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.main,
    ),
    textTheme: const TextTheme(
      headline1: AppFonts.timer,
      bodyText1: AppFonts.text,
      button: AppFonts.button,
    ),
  );
}
