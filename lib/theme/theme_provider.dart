import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../theme/app_theme.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, FlowThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<FlowThemeMode> {
  ThemeModeNotifier() : super(_load());

  static FlowThemeMode _load() {
    final mode = Hive.box('settings').get('themeMode', defaultValue: 'seasonal');
    return FlowThemeMode.values.firstWhere((e) => e.name == mode, orElse: () => FlowThemeMode.seasonal);
  }

  void setTheme(FlowThemeMode mode) {
    state = mode;
    Hive.box('settings').put('themeMode', mode.name);
  }
}
