import 'package:hive/hive.dart';
import 'package:meditation_controll/domain/entity/meditation.dart';

class MeditationDataProvider {
  static const String _boxName = 'meditation';

  MeditationDataProvider() {
    _init();
  }
  late Future<Box<Meditation>> _box;

  Future<void> _init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MeditationAdapter());
    }
    _box = Hive.openBox<Meditation>(_boxName);
  }

  Future<void> close() async {
    await (await _box).close();
  }

  Future<void> saveRecord(Meditation meditation) async {
    (await _box).add(meditation);
  }

  Future<List<Meditation>> loadRecords() async {
    return (await _box).values.toList();
  }
}
