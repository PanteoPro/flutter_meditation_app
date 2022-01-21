part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  const TimerState({required this.duration});

  final int duration;

  @override
  List<Object?> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial({int duration = 300}) : super(duration: duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerRunPause extends TimerState {
  const TimerRunPause({required int duration}) : super(duration: duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

class TimerRunProgress extends TimerState {
  const TimerRunProgress({required int duration}) : super(duration: duration);

  @override
  String toString() => 'TimerRunProgress { duration: $duration }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete({required int duration}) : super(duration: duration);

  @override
  String toString() => 'TimerRunComplete { duration: $duration }';
}

class TimerRunEnd extends TimerState {
  const TimerRunEnd({required int meditationSeconds}) : super(duration: meditationSeconds);

  @override
  String toString() => 'TimerRunEnd { meditationSeconds: $duration }';
}
