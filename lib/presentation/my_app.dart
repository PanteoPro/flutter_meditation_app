import 'package:flutter/material.dart';
import 'package:meditation_controll/Themes/app_themes.dart';
import 'package:meditation_controll/presentation/routes/main_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainRouter _mainRouter = MainRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      initialRoute: _mainRouter.initialRoute,
      routes: _mainRouter.routes,
    );
  }
}
