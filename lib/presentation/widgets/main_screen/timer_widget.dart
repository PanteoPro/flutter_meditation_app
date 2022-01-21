import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/Themes/app_fonts.dart';
import 'package:meditation_controll/Widgets/button.dart';
import 'package:meditation_controll/Widgets/circle_progress.dart';
import 'package:meditation_controll/logic/bloc/timer_bloc.dart';
import 'package:meditation_controll/presentation/routes/main_router.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width - 24 - 20 * 4;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * .15,
              height: width * .15,
              child: BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) {
                  if (state is TimerInitial && state.duration > 60) {
                    return _TimerButtonAdderWidget(
                      text: '-1',
                      onPressed: () => context.read<TimerBloc>().add(
                            const TimerChanged(seconds: -60),
                          ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            SizedBox(
              width: width * .8,
              height: width * .8,
              child: BlocBuilder<TimerBloc, TimerState>(
                buildWhen: (previous, current) => current is TimerInitial,
                builder: (context, state) {
                  return _TimerTimeWidget(duration: state.duration);
                },
              ),
            ),
            SizedBox(
              width: width * .15,
              height: width * .15,
              child: BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) {
                  if (state is TimerInitial && state.duration < 99 * 60) {
                    return _TimerButtonAdderWidget(
                      text: '+1',
                      onPressed: () => context.read<TimerBloc>().add(
                            const TimerChanged(seconds: 60),
                          ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _TimerActions(),
      ],
    );
  }
}

class _TimerTimeWidget extends StatelessWidget {
  const _TimerTimeWidget({
    Key? key,
    required int duration,
  })  : _startDuration = duration,
        super(key: key);

  final int _startDuration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, current) => prev.duration != current.duration,
      builder: (context, state) {
        final duration = state.duration < 0 ? -state.duration : state.duration;
        final isEnd = state is TimerRunComplete;
        final minutesStr = ((duration / 60) % 100).floor().toString().padLeft(2, '0');
        final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
        final timeStr = '$minutesStr:$secondsStr';

        return CircleProgressWidget(
          percent: !isEnd ? duration / _startDuration : 1,
          lineColor: isEnd ? AppColors.green : AppColors.main,
          lineWidth: 4,
          child: Text(
            isEnd ? '+$timeStr' : timeStr,
            style: AppFonts.timer,
          ),
        );
      },
    );
  }
}

class _TimerButtonAdderWidget extends StatelessWidget {
  const _TimerButtonAdderWidget({Key? key, required this.text, required this.onPressed}) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(text, style: AppFonts.button),
        ),
      ),
    );
  }
}

class _TimerActions extends StatelessWidget {
  const _TimerActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final isToCenter = state is TimerInitial || state is TimerRunComplete;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is TimerInitial) ...[
                _TimerActionsButtonWidget(
                  color: AppColors.main,
                  onPressed: () => context.read<TimerBloc>().add(TimerStarted(duration: state.duration)),
                  text: 'Начать',
                ),
                _TimerActionsButtonWidget(
                  color: AppColors.main,
                  onPressed: () => Navigator.of(context).pushNamed(MainRouterNames.statistics),
                  text: 'Статистика',
                ),
              ],
              if (state is TimerRunProgress) ...[
                _TimerActionsButtonWidget(
                  color: AppColors.red,
                  onPressed: () => context.read<TimerBloc>().add(const TimerPaused()),
                  text: 'Пауза',
                ),
                _TimerActionsButtonWidget(
                  color: AppColors.main,
                  onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                  text: 'Закончить',
                ),
              ],
              if (state is TimerRunPause) ...[
                _TimerActionsButtonWidget(
                  color: AppColors.main,
                  onPressed: () => context.read<TimerBloc>().add(const TimerResumed()),
                  text: 'Продолжить',
                ),
                _TimerActionsButtonWidget(
                  color: AppColors.main,
                  onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                  text: 'Закончить',
                ),
              ],
              if (state is TimerRunComplete)
                _TimerActionsButtonWidget(
                  color: AppColors.green,
                  onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                  text: 'Закончить медитацию',
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TimerActionsButtonWidget extends StatelessWidget {
  const _TimerActionsButtonWidget({
    Key? key,
    required this.color,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final Color color;
  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final minWidth = size.width - 24;
    final maxWidth = size.width * 0.5 - 24;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: minWidth, minWidth: maxWidth),
      child: MyButton(
        color: color,
        onPressed: onPressed,
        text: text,
      ),
    );
  }
}
