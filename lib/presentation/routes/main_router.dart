import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditation_controll/logic/bloc/timer_bloc.dart';
import 'package:meditation_controll/logic/cubit/music_cubit.dart';
import 'package:meditation_controll/logic/cubit/save_cubit.dart';
import 'package:meditation_controll/logic/cubit/statistics_cubit.dart';
import 'package:meditation_controll/logic/cubit/vibration_cubit.dart';
import 'package:meditation_controll/logic/ticker.dart';
import 'package:meditation_controll/presentation/screens/main_screen.dart';
import 'package:meditation_controll/presentation/screens/settiings_screen.dart';
import 'package:meditation_controll/presentation/screens/statistics_screen.dart';

abstract class MainRouterNames {
  static const String main = '/';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
}

class MainRouter {
  final initialRoute = MainRouterNames.main;

  final Map<String, Widget Function(BuildContext)> routes = {
    MainRouterNames.main: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(ticker: const Ticker()),
            ),
            BlocProvider(
              create: (context) => SaveCubit(timerBloc: context.read<TimerBloc>()),
              lazy: false,
            ),
            BlocProvider(
              create: (context) => MusicCubit(timerBloc: context.read<TimerBloc>()),
              lazy: false,
            ),
            BlocProvider(
              create: (context) => VibrationCubit(timerBloc: context.read<TimerBloc>()),
              lazy: false,
            ),
          ],
          child: const MainScreen(),
        ),
    MainRouterNames.statistics: (ctx) => BlocProvider(
          create: (context) => StatisticsCubit(),
          child: const StatisticsScreen(),
        ),
    MainRouterNames.settings: (ctx) => const SettingsScreen(),
  };
}
