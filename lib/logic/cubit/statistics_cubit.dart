import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_controll/domain/entity/meditation.dart';
import 'package:meditation_controll/domain/repositories/meditation_repository.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final _meditationRepository = MeditationRepository();
  StreamSubscription<dynamic>? _meditationSubscription;

  StatisticsCubit() : super(const StatisticsLoading()) {
    _meditationSubscription = MeditationRepository.stream?.listen(_onListenRepository);
  }

  Future<void> _onListenRepository(dynamic event) async {
    emit(StatisticsLoaded(meditation: _meditationRepository.getMeditations()));
  }

  @override
  Future<void> close() {
    _meditationSubscription?.cancel();
    return super.close();
  }

  void weekMeditation() {
    if (state.period != StatisticsPeriod.week) {
      emit(
        StatisticsLoaded(
          meditation: _meditationRepository.getMeditationsByDateWeek(DateTime.now()),
          period: StatisticsPeriod.week,
        ),
      );
    }
  }

  void monthMeditation() {
    if (state.period != StatisticsPeriod.month) {
      emit(
        StatisticsLoaded(
          meditation: _meditationRepository.getMeditationsByDateMonth(DateTime.now()),
          period: StatisticsPeriod.month,
        ),
      );
    }
  }

  void allMeditation() {
    if (state.period != StatisticsPeriod.all) {
      emit(
        StatisticsLoaded(
          meditation: _meditationRepository.getMeditations(),
          period: StatisticsPeriod.all,
        ),
      );
    }
  }
}
