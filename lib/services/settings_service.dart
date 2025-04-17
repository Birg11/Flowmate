import 'package:hive/hive.dart';

class SettingsService {
  static final _box = Hive.box('settings');

  static DateTime? get cycleStartDate {
    final raw = _box.get('cycleStartDate');
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  static set cycleStartDate(DateTime? value) {
    if (value != null) {
      _box.put('cycleStartDate', value.toIso8601String());
    }
  }

  static bool get notificationsEnabled =>
      _box.get('notifications', defaultValue: true);

  static set notificationsEnabled(bool value) =>
      _box.put('notifications', value);

  static bool get onboardingComplete =>
      _box.get('onboardingComplete', defaultValue: false);

  static set onboardingComplete(bool value) =>
      _box.put('onboardingComplete', value);

  static String? get companionNumber => _box.get('companionNumber');

  static set companionNumber(String? number) =>
      _box.put('companionNumber', number);

  // ✅ Explicit method to update and save cycle date
  static Future<void> updateCycleStartDate(DateTime date) async {
    await _box.put('cycleStartDate', date.toIso8601String());
  }
}
