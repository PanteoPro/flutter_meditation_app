import 'package:hive/hive.dart';

part 'meditation.g.dart';

@HiveType(typeId: 0)
class Meditation {
  const Meditation({required this.date, required this.seconds});

  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int seconds;

  @override
  String toString() => 'Meditation(date: $date, seconds: $seconds)';

  Meditation copyWith({
    DateTime? date,
    int? seconds,
  }) {
    return Meditation(
      date: date ?? this.date,
      seconds: seconds ?? this.seconds,
    );
  }
}
