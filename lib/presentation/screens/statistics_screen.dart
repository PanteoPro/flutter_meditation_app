import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:meditation_controll/Themes/app_colors.dart';
import 'package:meditation_controll/Themes/app_fonts.dart';
import 'package:meditation_controll/domain/entity/meditation.dart';
import 'package:meditation_controll/logic/cubit/statistics_cubit.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _ChartWidget(),
          SizedBox(height: 20),
          _ActionsWidget(),
        ],
      ),
    );
  }
}

class _ActionsWidget extends StatelessWidget {
  const _ActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StatisticsCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _ActionItemWidget(
                  title: 'За неделю',
                  onPressed: () => cubit.weekMeditation(),
                  isActivate: state.period == StatisticsPeriod.week ? true : false,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _ActionItemWidget(
                  title: 'За месяц',
                  onPressed: () => cubit.monthMeditation(),
                  isActivate: state.period == StatisticsPeriod.month ? true : false,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _ActionItemWidget(
                  title: 'За все время',
                  onPressed: () => cubit.allMeditation(),
                  isActivate: state.period == StatisticsPeriod.all ? true : false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionItemWidget extends StatelessWidget {
  const _ActionItemWidget({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.isActivate,
  }) : super(key: key);

  final String title;
  final VoidCallback? onPressed;
  final bool isActivate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.main, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppFonts.settings.copyWith(color: isActivate ? AppColors.main : AppColors.white),
          ),
        ),
      ),
    );
  }
}

class _ChartWidget extends StatefulWidget {
  const _ChartWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<_ChartWidget> {
  late TooltipBehavior _tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return SizedBox(
              width: MediaQuery.of(context).size.height * 0.4,
              child: const CircularProgressIndicator(color: AppColors.main),
            );
          }
          var data = _dataByMeditations(state);
          final double maximum = _getMaximumChart(data);
          return _ChartSeriesWidget(maximum: maximum, tooltip: _tooltip, data: data);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setTooltip();
  }

  String _minutesString(int seconds) {
    final minutes = (seconds / 60).round();
    final endMinutes = ['а', 'ы', ''];
    final n = minutes % 100;
    String? end;
    if (n >= 11 && n <= 19) {
      end = endMinutes[2];
    } else {
      final i = n % 10;
      if (i == 1) {
        end = endMinutes[0];
      } else if (i >= 2 && i <= 4) {
        end = endMinutes[1];
      } else {
        end = endMinutes[2];
      }
    }
    return '$minutes минут$end';
  }

  String _dateString(DateTime date) {
    final days = date.day < 10 ? "0${date.day}" : date.day;
    final month = date.month < 10 ? "0${date.month}" : date.month;
    return '$days.$month';
  }

  void _setTooltip([bool isWeek = false]) {
    _tooltip = TooltipBehavior(
      enable: true,
      opacity: 0,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        final chartData = data as _ChartData;
        final dateString = _dateString(chartData.date);
        final message = _minutesString((chartData.minutes * 60).ceil());
        final child = isWeek
            ? Text(message)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$dateString.${chartData.date.year}'),
                  Text(message),
                ],
              );
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.main),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: child,
          ),
        );
      },
    );
  }

  List<_ChartData> _dataByMeditations(StatisticsState state) {
    final data = <_ChartData>[];
    _setTooltip();
    switch (state.period) {
      case StatisticsPeriod.week:
        _setTooltip(true);
        data.addAll(_dataByWeek(state.meditation));
        break;
      case StatisticsPeriod.month:
        data.addAll(_dataByMonth(state.meditation));
        break;
      case StatisticsPeriod.all:
        data.addAll(_dataAll(state.meditation));
        break;
    }
    return data;
  }

  List<_ChartData> _dataByWeek(List<Meditation> meditations) {
    final date = DateTime.now();
    final startWeek = DateTime(date.year, date.month, date.day - date.weekday + 1);
    final endWeek = DateTime(startWeek.year, startWeek.month, startWeek.day + 7).add(const Duration(milliseconds: -1));

    final daysOfWeek = [
      'Пн',
      'Вт',
      'Ср',
      'Чт',
      'Пт',
      'Сб',
      'Вс',
    ];
    final data = List.generate(
      7,
      (index) => _ChartData(
        startWeek.add(Duration(days: index)),
        0,
        daysOfWeek[index],
      ),
    );

    for (final meditation in meditations) {
      final weekday = meditation.date.weekday;
      if (meditation.date.isAfter(startWeek) && meditation.date.isBefore(endWeek)) {
        data[weekday - 1] = data[weekday - 1].copyWith(
          minutes: data[weekday - 1].minutes + meditation.seconds / 60,
          color: weekday == DateTime.now().weekday ? AppColors.green : AppColors.main,
        );
      }
    }
    return data;
  }

  List<_ChartData> _dataByMonth(List<Meditation> meditations) {
    final date = DateTime.now();
    final startMonth = DateTime(date.year, date.month, 1);
    final endMonth = DateTime(date.year, date.month + 1, 1).add(const Duration(milliseconds: -1));
    final data = List.generate(
      endMonth.day,
      (index) => _ChartData(
        startMonth.add(Duration(days: index)),
        0,
        _dateString(DateTime(startMonth.year, startMonth.month, index + 1)),
      ),
    );
    for (final meditation in meditations) {
      final monthDay = meditation.date.day;
      if (meditation.date.isBefore(endMonth)) {
        data[monthDay - 1] = data[monthDay - 1].copyWith(
          minutes: data[monthDay - 1].minutes + meditation.seconds / 60,
          color: monthDay == DateTime.now().day ? AppColors.green : AppColors.main,
        );
      }
    }
    return data;
  }

  List<_ChartData> _dataAll(List<Meditation> meditations) {
    if (meditations.isNotEmpty) {
      final minMeditationByDate = meditations.reduce((a, b) => a.date.isBefore(b.date) ? a : b);
      final maxMeditationByDate = meditations.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
      var minDate =
          DateTime(minMeditationByDate.date.year, minMeditationByDate.date.month, minMeditationByDate.date.day);
      final maxDate =
          DateTime(maxMeditationByDate.date.year, maxMeditationByDate.date.month, maxMeditationByDate.date.day);

      int difDays = maxDate.difference(minDate).inDays;
      if (difDays > 90) {
        final changeDifference = difDays - 90;
        difDays = 90;
        minDate = minDate.add(Duration(days: changeDifference));
        print(minDate);
      }
      final data = List.generate(
        difDays + 1,
        (index) => _ChartData(
          minDate.add(Duration(days: index)),
          0,
          _dateString(DateTime(minDate.year, minDate.month, minDate.day + index)),
        ),
      );
      for (final meditation in meditations) {
        final date = meditation.date;
        final normilizeDate = DateTime(date.year, date.month, date.day);
        final index = normilizeDate.difference(minDate).inDays;
        if (index >= 0 && index <= 90) {
          data[index] = data[index].copyWith(
            minutes: data[index].minutes + meditation.seconds / 60,
          );
        }
      }
      return data;
    }
    return [];
  }

  double _getMaximumChart(List<_ChartData> data) {
    var maximum = 20.0;
    if (data.isNotEmpty) {
      maximum = max(data.reduce((a, b) => a.minutes > b.minutes ? a : b).minutes * 1.2, maximum);
    }
    return maximum;
  }
}

class _ChartSeriesWidget extends StatelessWidget {
  const _ChartSeriesWidget({
    Key? key,
    required this.maximum,
    required TooltipBehavior tooltip,
    required this.data,
  })  : _tooltip = tooltip,
        super(key: key);

  final double maximum;
  final TooltipBehavior _tooltip;
  final List<_ChartData> data;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      backgroundColor: AppColors.background,
      plotAreaBorderColor: Color(0xFF363C4E).withOpacity(0),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 1,
          color: Color(0xFF363C4E).withOpacity(0.2),
        ),
        axisLine: AxisLine(color: Color(0xFF363C4E).withOpacity(0)),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: maximum,
        interval: 5,
        majorGridLines: MajorGridLines(
          width: 1,
          color: Color(0xFF363C4E).withOpacity(0),
        ),
        axisLine: AxisLine(color: Color(0xFF363C4E).withOpacity(0)),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      tooltipBehavior: _tooltip,
      series: <ChartSeries<_ChartData, String>>[
        ColumnSeries(
            color: AppColors.main,
            dataSource: data,
            xValueMapper: (_ChartData data, _) => data.text,
            yValueMapper: (_ChartData data, _) => data.minutes,
            pointColorMapper: (_ChartData data, _) => data.color),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.minutes, this.text, [this.color = AppColors.main]);

  final DateTime date;
  final String text;
  final double minutes;
  final Color color;

  _ChartData copyWith({
    DateTime? date,
    String? text,
    double? minutes,
    Color? color,
  }) {
    return _ChartData(
      date ?? this.date,
      minutes ?? this.minutes,
      text ?? this.text,
      color ?? this.color,
    );
  }
}
