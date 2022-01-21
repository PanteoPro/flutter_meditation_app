import 'dart:async';

import 'package:meditation_controll/domain/data_providers/meditation_data_provider.dart';
import 'package:meditation_controll/domain/entity/meditation.dart';

class MeditationRepository {
  MeditationRepository() {
    _init();
  }
  final _meditationDataProvider = MeditationDataProvider();
  final List<Meditation> _meditations = [];
  List<Meditation> getMeditations() => List.unmodifiable(_meditations);

  static final _streamController = StreamController<dynamic>();
  static Stream<dynamic>? stream;

  Future<void> _init() async {
    stream ??= _streamController.stream.asBroadcastStream();
    await _updateData();
  }

  Future<void> _updateData() async {
    _meditations.clear();
    _meditations.addAll(await _meditationDataProvider.loadRecords());
    _streamController.add('update');
  }

  Future<void> addRecord(Meditation meditation) async {
    await _meditationDataProvider.saveRecord(meditation);
    await _updateData();
  }

  List<Meditation> getMeditationsByDateDay(DateTime date) {
    final startDay = date.add(Duration(
      milliseconds: -date.millisecond,
      seconds: -date.second,
      minutes: -date.minute,
      hours: -date.hour,
    ));
    final endDay = date.add(Duration(
      milliseconds: -date.millisecond - 1,
      seconds: -date.second,
      minutes: -date.minute,
      hours: 24 - date.hour,
    ));
    return List.unmodifiable(_meditations
        .where((meditation) => meditation.date.isAfter(startDay) && meditation.date.isBefore(endDay))
        .toList());
  }

  List<Meditation> getMeditationsByDateWeek(DateTime date) {
    final startWeek = DateTime(date.year, date.month, date.day - date.weekday + 1);
    final endWeek = DateTime(startWeek.year, startWeek.month, startWeek.day + 7).add(const Duration(milliseconds: -1));

    return List.unmodifiable(_meditations
        .where((meditation) => meditation.date.isAfter(startWeek) && meditation.date.isBefore(endWeek))
        .toList());
  }

  List<Meditation> getMeditationsByDateMonth(DateTime date) {
    final startMonth = DateTime(date.year, date.month, 1);
    final endMonth = DateTime(date.year, date.month + 1, 1).add(const Duration(milliseconds: -1));
    return List.unmodifiable(_meditations
        .where((meditation) => meditation.date.isAfter(startMonth) && meditation.date.isBefore(endMonth))
        .toList());
  }
}
