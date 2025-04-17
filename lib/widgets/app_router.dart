import 'package:flowmate/screens/calendar_screen.dart';
import 'package:flowmate/screens/chat_screen.dart';
import 'package:flowmate/screens/home_screen.dart';
import 'package:flowmate/screens/insights_screen.dart';
import 'package:flowmate/screens/log_screen.dart';
import 'package:flowmate/screens/onboarding_screen.dart';
import 'package:flowmate/screens/settings_screen.dart';
import 'package:flowmate/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) =>  HomeScreen(),
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/log/:date',
        name: 'log',
        builder: (context, state) {
          final dateParam = state.pathParameters['date']!;
          final logDate = DateTime.parse(dateParam);
          return LogScreen(date: logDate);
        },
      ),
      GoRoute(
        path: '/insights',
        name: 'insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
  GoRoute(
  path: '/chat',
  name: 'chat',
  builder: (context, state) {
    return ChatScreen(contextData: state.extra);
  },
),

    ],
  );
}
