import 'package:hive/hive.dart';

class LogService {
  final _box = Hive.box('logs');

  Future<void> saveLog(DateTime day, Map<String, dynamic> logData) async {
    await _box.put(day.toIso8601String(), logData);
  }

  Map<String, dynamic>? getLog(DateTime day) {
    return _box.get(day.toIso8601String());
  }

  List<Map<String, dynamic>> getAllLogs() {
    return _box.values.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
