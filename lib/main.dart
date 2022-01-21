import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/presentation/my_app.dart';

Future<void> main() async {
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('meditation');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.background, // navigation bar color
    statusBarColor: AppColors.background, // status bar color
  ));

  runApp(const MyApp());
}
