part of 'music_cubit.dart';

abstract class MusicState extends Equatable {
  const MusicState({required this.isMusicMuted});

  final bool isMusicMuted;

  @override
  List<Object> get props => [isMusicMuted];
}

class MusicInitial extends MusicState {
  const MusicInitial({required bool isMusicMuted}) : super(isMusicMuted: isMusicMuted);
}
