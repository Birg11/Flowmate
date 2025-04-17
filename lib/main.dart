import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'widgets/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('logs');
  await Hive.openBox('settings');
  //  await NotificationService.init(); // 🔔 INIT

  runApp(const ProviderScope(child: FlowMateApp()));
}

class FlowMateApp extends ConsumerWidget {
  const FlowMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeMode == FlowThemeMode.seasonal
          ? AppTheme.seasonalLight()
          : AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode:
          themeMode == FlowThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
