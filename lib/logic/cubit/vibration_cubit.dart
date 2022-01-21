import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_controll/logic/bloc/timer_bloc.dart';
import 'package:vibration/vibration.dart';

part 'vibration_state.dart';

class VibrationCubit extends Cubit<VibrationState> {
  final TimerBloc _timerBloc;
  StreamSubscription<TimerState>? _timerBlocSubscription;

  VibrationCubit({required TimerBloc timerBloc})
      : _timerBloc = timerBloc,
        super(VibrationChecking()) {
    _timerBlocSubscription = _timerBloc.stream.listen(_onListenTimer);
    _checkVibration();
  }

  Future<void> _checkVibration() async {
    Vibration.hasVibrator().then((isHaveVibro) {
      if (isHaveVibro != null) {
        if (isHaveVibro) {
          emit(VibrationHave());
        }
      } else {
        emit(VibrationError());
      }
    });
  }

  Future<void> _onListenTimer(TimerState timerState) async {
    if (timerState is TimerRunComplete && state is VibrationHave && timerState.duration == 0) {
      Vibration.vibrate(pattern: [0, 500, 500, 500, 500, 500, 500, 1000]);
    }
  }

  @override
  Future<void> close() {
    _timerBlocSubscription?.cancel();
    return super.close();
  }
}
