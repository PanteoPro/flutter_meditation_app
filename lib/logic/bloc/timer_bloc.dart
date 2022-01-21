import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_controll/logic/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 600;
  int countSeconds = 0;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() async {
    _tickerSubscription?.cancel();
    super.close();
  }

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(duration: _duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerChanged>(_onChanged);
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    countSeconds = 0;
    emit(TimerRunProgress(duration: event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: event.duration).listen((duration) {
      add(TimerTicked(duration: duration));
      countSeconds++;
    });
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0 ? TimerRunProgress(duration: event.duration) : TimerRunComplete(duration: event.duration));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(duration: state.duration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunProgress(duration: state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerRunEnd(meditationSeconds: countSeconds));
    emit(const TimerInitial(duration: _duration));
  }

  void _onChanged(TimerChanged event, Emitter<TimerState> emit) {
    if (state is TimerInitial) {
      if (state.duration + event.seconds > 0) {
        emit(TimerInitial(duration: state.duration + event.seconds));
      }
    }
  }
}
