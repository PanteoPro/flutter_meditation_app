import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_controll/domain/entity/meditation.dart';
import 'package:meditation_controll/domain/repositories/meditation_repository.dart';
import 'package:meditation_controll/logic/bloc/timer_bloc.dart';

part 'save_state.dart';

class SaveCubit extends Cubit<SaveState> {
  final TimerBloc _timerBloc;
  StreamSubscription<TimerState>? _timerBlocSubscription;

  final _meditationRepository = MeditationRepository();

  SaveCubit({required TimerBloc timerBloc})
      : _timerBloc = timerBloc,
        super(const SaveInitial()) {
    _timerBlocSubscription = _timerBloc.stream.listen(_onListenTimer);
  }

  Future<void> _onListenTimer(TimerState state) async {
    if (state is TimerRunEnd) {
      if (state.duration >= 60) {
        await _saveRecord(seconds: state.duration);
        print('Meditation is save seconds - ${state.duration}');
      } else {
        print('Meditation is NOT SAVE, dont enought seconds ${state.duration}');
      }
    }
  }

  Future<void> _saveRecord({required int seconds}) async {
    final startMeditation = DateTime.now().add(Duration(seconds: -seconds));
    await _meditationRepository.addRecord(Meditation(date: startMeditation, seconds: seconds));
  }

  @override
  Future<void> close() {
    _timerBlocSubscription?.cancel();
    return super.close();
  }
}
