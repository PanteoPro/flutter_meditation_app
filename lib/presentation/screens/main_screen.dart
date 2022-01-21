import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/Themes/app_fonts.dart';
import 'package:meditation_controll/Widgets/button.dart';
import 'package:meditation_controll/Widgets/circle_progress.dart';
import 'package:meditation_controll/logic/bloc/timer_bloc.dart';
import 'package:meditation_controll/logic/cubit/music_cubit.dart';
import 'package:meditation_controll/logic/cubit/save_cubit.dart';
import 'package:meditation_controll/presentation/routes/main_router.dart';
import 'package:meditation_controll/presentation/widgets/main_screen/music_widget.dart';
import 'package:meditation_controll/presentation/widgets/main_screen/timer_widget.dart';
import 'package:meditation_controll/resources/resources.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final musicCubit = context.read<MusicCubit>();
    if (state == AppLifecycleState.inactive) {
      musicCubit.pause();
    } else if (state == AppLifecycleState.resumed) {
      musicCubit.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: const [
              Expanded(
                child: _SettingsWidget(),
              ),
              Expanded(flex: 3, child: TimerWidget()),
              Expanded(flex: 2, child: MusicViewWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsWidget extends StatelessWidget {
  const _SettingsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(MainRouterNames.settings),
            child: Image.asset(AppImagesIcons.settings, width: 32, height: 32)),
      ),
    );
  }
}
