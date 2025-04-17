import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/settings_service.dart';
import '../theme/seasonal_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final int cycleLength = 28;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  Season getSeasonForDate(DateTime date) {
    final start = SettingsService.cycleStartDate;
    if (start == null) return Season.spring;

    final daysSinceStart = date.difference(start).inDays;
    final dayInCycle = (daysSinceStart % cycleLength + cycleLength) % cycleLength;

    if (dayInCycle <= 5) return Season.winter;
    if (dayInCycle <= 13) return Season.spring;
    if (dayInCycle <= 17) return Season.summer;
    return Season.autumn;
  }

  List<Color> getColors(Season season) {
    switch (season) {
      case Season.spring:
        return SeasonalColors.spring;
      case Season.summer:
        return SeasonalColors.summer;
      case Season.autumn:
        return SeasonalColors.autumn;
      case Season.winter:
        return SeasonalColors.winter;
    }
  }

  String getSeasonName(Season season) {
    switch (season) {
      case Season.spring:
        return "Spring";
      case Season.summer:
        return "Summer";
      case Season.autumn:
        return "Autumn";
      case Season.winter:
        return "Winter";
    }
  }

  String getPhaseTip(Season season) {
    switch (season) {
      case Season.spring:
        return "Energy is rising — create and explore 🌱";
      case Season.summer:
        return "You’re glowing — socialize and shine ☀️";
      case Season.autumn:
        return "Reflect and reset 🍂";
      case Season.winter:
        return "Time to rest and restore ❄️";
    }
  }

  @override
  Widget build(BuildContext context) {
    final season = _selectedDay != null ? getSeasonForDate(_selectedDay!) : Season.spring;
    final phaseName = getSeasonName(season);
    final phaseColors = getColors(season);
    final phaseTip = getPhaseTip(season);

    return Scaffold(
      appBar: AppBar(title: const Text("Cycle Calendar")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final season = getSeasonForDate(day);
                final color = getColors(season).first.withOpacity(0.3);
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  alignment: Alignment.center,
                  child: Text("${day.day}", style: const TextStyle(color: Colors.black)),
                );
              },
              todayBuilder: (context, day, _) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pinkAccent,
                  ),
                  alignment: Alignment.center,
                  child: Text("${day.day}", style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🌙 ${getSeasonName(season)} Phase", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(getPhaseTip(season), style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
