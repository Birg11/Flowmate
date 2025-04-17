import 'dart:async';
import 'package:flowmate/widgets/cycle_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowmate/services/cycle_start_provider.dart';
import 'package:flowmate/services/log_service.dart';
import 'package:flowmate/theme/seasonal_colors.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cycleStart = ref.watch(cycleStartProvider);
    final logs = LogService().getAllLogs();
    final today = DateTime.now();

    if (cycleStart == null) {
      return const Scaffold(body: Center(child: Text("Cycle start date not set.")));
    }

    final day = calculateCycleDay(cycleStart, today);
    final season = _getSeason(day);
    final emoji = _seasonEmoji(season);
    final label = "${season.name.toUpperCase()} $emoji";

    return Scaffold(
      appBar: AppBar(title: const Text("Cycle Insights")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Day $day of 28 — $label",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildCycleBar(day),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  final log = logs[index];
                  final date = DateTime.tryParse(log['date'] ?? '');
                  if (date == null) return const SizedBox();

                  final mood = log['mood'] ?? '–';
                  final flow = log['flow'] ?? '–';
                  final note = log['note'] ?? '';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        "Day ${calculateCycleDay(cycleStart, date)} - ${date.toLocal().toString().split(' ')[0]}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mood: $mood   Flow: $flow"),
                          if (note.isNotEmpty) Text("Note: $note"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Season _getSeason(int day) {
    if (day <= 5) return Season.winter;
    if (day <= 13) return Season.spring;
    if (day <= 17) return Season.summer;
    return Season.autumn;
  }

  String _seasonEmoji(Season season) {
    switch (season) {
      case Season.spring:
        return "🌸";
      case Season.summer:
        return "☀️";
      case Season.autumn:
        return "🍂";
      case Season.winter:
        return "❄️";
    }
  }

  Widget _buildCycleBar(int currentDay) {
    return SizedBox(
      height: 24,
      child: Row(
        children: List.generate(28, (i) {
          final dayNum = i + 1;
          final isToday = dayNum == currentDay;
          final season = _getSeason(dayNum);
          final colors = SeasonalColors.bySeason(season);

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: isToday ? colors.first : colors.first.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
                border: isToday ? Border.all(color: Colors.black87, width: 1.2) : null,
              ),
              child: isToday
                  ? Center(
                      child: Text(
                        "$dayNum",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }),
      ),
    );
  }
}
