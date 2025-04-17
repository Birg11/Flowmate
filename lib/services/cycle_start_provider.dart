import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowmate/services/settings_service.dart';

final cycleStartProvider = StateProvider<DateTime?>((ref) {
  return SettingsService.cycleStartDate;
});
