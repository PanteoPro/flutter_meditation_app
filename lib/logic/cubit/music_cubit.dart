import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_controll/logic/bloc/timer_bloc.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  final TimerBloc _timerBloc;
  StreamSubscription<TimerState>? _timerBlocSubscription;

  final AudioCache _playerCacheOnEnd = AudioCache();
  AudioPlayer? _playerOnEnd;

  bool _isMusicPlayed = false;

  MusicCubit({required TimerBloc timerBloc})
      : _timerBloc = timerBloc,
        super(const MusicInitial(isMusicMuted: false)) {
    _timerBlocSubscription = _timerBloc.stream.listen(_onListenTimer);
  }

  Future<void> _onListenTimer(TimerState timerState) async {
    if (timerState is TimerRunComplete && _isMusicPlayed == false) {
      _isMusicPlayed = true;
      if (!state.isMusicMuted) {
        _playerOnEnd = await _playerCacheOnEnd.play('audio/end_meditation.mp3');
      }
    }
    if (timerState is TimerInitial) {
      _isMusicPlayed = false;
      await _playerOnEnd?.stop();
    }
  }

  void onMute() {
    if (!state.isMusicMuted) {
      _playerOnEnd?.stop();
    }
    emit(const MusicInitial(isMusicMuted: true));
  }

  void onUnmute() {
    emit(const MusicInitial(isMusicMuted: false));
  }

  void pause() {
    if (_isMusicPlayed) {
      _playerOnEnd?.pause();
    }
  }

  void resume() {
    if (_isMusicPlayed) {
      _playerOnEnd?.resume();
    }
  }

  @override
  Future<void> close() {
    _timerBlocSubscription?.cancel();
    _playerCacheOnEnd.clearAll();
    _playerOnEnd?.stop();
    return super.close();
  }
}
