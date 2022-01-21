part of 'statistics_cubit.dart';

enum StatisticsPeriod {
  week,
  month,
  all,
}

abstract class StatisticsState extends Equatable {
  const StatisticsState({required this.meditation, StatisticsPeriod? period})
      : period = period ?? StatisticsPeriod.week;

  final List<Meditation> meditation;
  final StatisticsPeriod period;

  @override
  List<Object> get props => [meditation, period];
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading() : super(meditation: const []);
}

class StatisticsLoaded extends StatisticsState {
  const StatisticsLoaded({required List<Meditation> meditation, StatisticsPeriod? period})
      : super(meditation: meditation, period: period);
}
