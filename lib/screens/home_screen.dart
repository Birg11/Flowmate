import 'dart:async';

import 'package:flowmate/services/cycle_start_provider.dart';
import 'package:flowmate/services/log_service.dart';
import 'package:flowmate/services/stealth_mode_provider.dart';
import 'package:flowmate/theme/seasonal_colors.dart';
import 'package:flowmate/widgets/cycle_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/affirmation_service.dart';
import '../../services/settings_service.dart';
import '../../widgets/cycle_visualization_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  List<Map<String, dynamic>> logs = [];
  bool _showCycleInfoCard = false;

  @override
  void initState() {
    super.initState();
    logs = LogService().getAllLogs();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        logs = LogService().getAllLogs();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
Season _getSeasonByCycle(DateTime? start, DateTime today) {
  if (start == null) {
    // Handle the null case, perhaps by returning a default season or throwing an error
    return Season.spring; // Example default value
  }

  final todayOnly = DateTime(today.year, today.month, today.day);
  final startOnly = DateTime(start.year, start.month, start.day);
  final daysSinceStart = todayOnly.difference(startOnly).inDays;

  final dayInCycle = ((daysSinceStart % 28) + 28) % 28 + 1;

  if (dayInCycle <= 5) return Season.winter;
  if (dayInCycle <= 13) return Season.spring;
  if (dayInCycle <= 17) return Season.summer;
  return Season.autumn;
}
int getCycleDay(DateTime? start) {
  if (start == null) return 1;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final startDate = DateTime(start.year, start.month, start.day);

  final diff = today.difference(startDate).inDays;

  if (diff < 0) return 1; // Future date fallback

  // Forward counting: Day 1 on start date, Day 2 next day, etc.
  return (diff % 28) + 1;
}






  String getSeasonEmoji(Season season) {
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

  String getSeasonTip(Season season) {
    switch (season) {
      case Season.spring:
        return "Energy is rising — plan and explore!";
      case Season.summer:
        return "You're at your peak — socialize and shine!";
      case Season.autumn:
        return "Reflect and slow down, prioritize calm.";
      case Season.winter:
        return "Rest deeply, journal, and nourish yourself.";
    }
  }

  String getSeasonFood(Season season) {
    switch (season) {
      case Season.spring:
        return "Leafy greens, seeds, and light proteins 🌿";
      case Season.summer:
        return "Fresh fruits, smoothies, and hydration 🍉";
      case Season.autumn:
        return "Root veggies, soups, magnesium-rich foods 🥕";
      case Season.winter:
        return "Iron-rich foods, warm stews, dark berries 🍲";
    }
  }

  final Map<String, String> _phaseDetails = {
    'Winter': "Menstruation phase. Time for rest, reflection, and softness.",
    'Spring': "Follicular phase. Energy rising. Great time to plan or create.",
    'Summer': "Ovulation phase. High energy and confidence. Socialize!",
    'Autumn': "Luteal phase. Reflective and emotional. Set boundaries, slow down.",
  };

  @override
  Widget build(BuildContext context) {
    final stealthMode = ref.watch(stealthModeProvider);
    final cycleStart = ref.watch(cycleStartProvider);
    final today = DateTime.now();
    final season = _getSeasonByCycle(cycleStart, today);
    final colors = _getColors(season);
    final emoji = getSeasonEmoji(season);
final cycleDay = getCycleDay(cycleStart);

  final todayLog = logs.firstWhere(
  (log) {
    final raw = log['date'];
    final parsed = DateTime.tryParse(raw ?? '');
    return parsed != null &&
        parsed.year == today.year &&
        parsed.month == today.month &&
        parsed.day == today.day;
  },
  orElse: () => {},
);

    final hasMood = todayLog['mood'] != null && todayLog['mood'].toString().trim().isNotEmpty;
    final hasFlow = todayLog['flow'] != null && todayLog['flow'].toString().trim().isNotEmpty;

    String defaultMood;
    String defaultFlow;

    switch (season) {
      case Season.winter:
        defaultMood = "💤 Tired";
        defaultFlow = "Heavy";
        break;
      case Season.spring:
        defaultMood = "🌱 Creative";
        defaultFlow = "Light";
        break;
      case Season.summer:
        defaultMood = "☀️ Confident";
        defaultFlow = "Dry";
        break;
      case Season.autumn:
        defaultMood = "🌧 Reflective";
        defaultFlow = "Spotting";
        break;
    }

    final mood = hasMood ? todayLog['mood'] : defaultMood;
    final flow = hasFlow ? todayLog['flow'] : defaultFlow;

    final affirmation = AffirmationService.getDailyAffirmation();
    final tip = getSeasonTip(season);
    final food = getSeasonFood(season);

return Scaffold(
  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    padding: const EdgeInsets.all(24),
    child: stealthMode
    ? const Center(child: Text("🔒 Stealth Mode is Active"))
    : LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 600 : double.infinity),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "$emoji ${season.name.toUpperCase()}",
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Day $cycleDay of 28",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    _buildCycleProgress(context, cycleDay),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Mood", mood),
                          _infoRow("Flow", flow),
                          const Divider(height: 32),
                          Text("💬 Affirmation", style: _sectionTitle),
                          const SizedBox(height: 6),
                          Text(affirmation, style: _sectionBody),
                          const SizedBox(height: 20),
                          Text("🌱 Phase Overview", style: _sectionTitle),
                          const SizedBox(height: 6),
                          Text(_getSeasonDescription(season), style: _sectionBody),
                          const SizedBox(height: 20),
                          Text("🍽️ Foods That Support You", style: _sectionTitle),
                          const SizedBox(height: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food, style: _sectionBody),
                              const SizedBox(height: 8),
                              Text(
                                "Source: 'In the FLO' by Alisa Vitti",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text("🧘 Self-Care Tips", style: _sectionTitle),
                          const SizedBox(height: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tip, style: _sectionBody),
                              const SizedBox(height: 8),
                              // Text(
                              //   "Source: Dr. Lara Briden, 'Period Repair Manual'",
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 13,
                              //     color: Colors.grey[700],
                              //     fontStyle: FontStyle.italic,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          );
        },
      ),

    // child: stealthMode
    //     ? const Center(child: Text("🔒 Stealth Mode is Active"))
    //     : SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const SizedBox(height: 20),
    //             Text(
    //               "$emoji ${season.name.toUpperCase()}",
    //               style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
    //             ),
    //             const SizedBox(height: 8),
    //             Text(
    //               "Day $cycleDay of 28",
    //               style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    //             ),
    //             const SizedBox(height: 16),
    //             _buildCycleProgress(context, cycleDay),
    //             const SizedBox(height: 24),
    //             Container(
    //               width: double.infinity,
    //               padding: const EdgeInsets.all(20),
    //               decoration: BoxDecoration(
    //                 color: Colors.white.withOpacity(0.9),
    //                 borderRadius: BorderRadius.circular(24),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   _infoRow("Mood", mood),
    //                   _infoRow("Flow", flow),
    //                   const Divider(height: 32),
    //                   Text("💬 Affirmation", style: _sectionTitle),
    //                   const SizedBox(height: 6),
    //                   Text(affirmation, style: _sectionBody),
    //                   const SizedBox(height: 20),
    //                   Text("🌱 Phase Overview", style: _sectionTitle),
    //                   const SizedBox(height: 6),
    //                   Text(_getSeasonDescription(season), style: _sectionBody),
    //                   const SizedBox(height: 20),
    //                   Text("🍽️ Foods That Support You", style: _sectionTitle),
    //                   const SizedBox(height: 6),
    //                   Text(food, style: _sectionBody),
    //                   const SizedBox(height: 20),
    //                   Text("🧘 Self-Care Tips", style: _sectionTitle),
    //                   const SizedBox(height: 6),
    //                   Text(tip, style: _sectionBody),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(height: 200),
    //           ],
    //         ),
    //       ),
  ),
  floatingActionButton: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (_showCycleInfoCard)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Your Cycle as Seasons", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  CycleVisualizationWidget(currentDay: cycleDay),
                  const SizedBox(height: 12),
                  const Text(
                    "Each color represents a phase of your 28-day cycle.\nTap the icon again to hide this.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      FloatingActionButton(
        heroTag: 'info_fab',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Your Cycle as Seasons",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CycleVisualizationWidget(currentDay: getCycleDay(ref.read(cycleStartProvider))),
                    const SizedBox(height: 16),
                    const Text(
                      "This chart visualizes your 28-day cycle.\nEach color represents a season-like phase.\nSwipe down to close.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.info_outline),
      ),
      const SizedBox(height: 12),
      FloatingActionButton.extended(
        heroTag: 'edit_cycle_fab',
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: ref.read(cycleStartProvider) ?? DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            await SettingsService.updateCycleStartDate(picked);
            ref.read(cycleStartProvider.notifier).state = picked;
            setState(() {});
          }
        },
        icon: const Icon(Icons.edit_calendar),
        label: const Text("Edit Cycle"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      const SizedBox(height: 12),
      FloatingActionButton.extended(
        heroTag: 'medical_info_fab',
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
  title: const Text('Medical Info'),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        'This section provides general health and cycle insights based on common phases in a 28-day menstrual cycle.',
      ),
      SizedBox(height: 16),
      Text(
        'Sources:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 4),
      Text(
        '• "Period Repair Manual" by Dr. Lara Briden\n'
        '• "In the FLO" by Alisa Vitti\n'
        '• World Health Organization (WHO)',
        style: TextStyle(fontSize: 14),
      ),
    ],
  ),
  actions: [
    TextButton(
      child: const Text('Close'),
      onPressed: () => Navigator.of(context).pop(),
    ),
  ],
)

          );
        },
        icon: const Icon(Icons.medical_services),
        label: const Text("Medical Info"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    ],
  ),
);

  }

  Widget _buildCycleProgress(BuildContext context, int day) {
    final segments = [
      {'range': 5, 'color': Colors.indigo, 'label': 'Winter'},
      {'range': 8, 'color': Colors.green, 'label': 'Spring'},
      {'range': 4, 'color': Colors.orange, 'label': 'Summer'},
      {'range': 11, 'color': Colors.brown, 'label': 'Autumn'},
    ];

    int offset = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: segments.map((seg) {
            final range = seg['range'] as int;
            final color = seg['color'] as Color;
            final label = seg['label'] as String;
            final active = day > offset && day <= offset + range;
            offset += range;

            return Expanded(
              flex: range,
              child: GestureDetector(
                onTap: () => _showPhaseInfo(context, label),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 10,
                  decoration: BoxDecoration(
                    color: active ? color : color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: segments.map((seg) {
            final label = seg['label'] as String;
            return Text(label, style: const TextStyle(fontSize: 12));
          }).toList(),
        ),
      ],
    );
  }

  void _showPhaseInfo(BuildContext context, String phase) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🌙 $phase Phase", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(_phaseDetails[phase]!, style: GoogleFonts.poppins(fontSize: 15)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getSeasonDescription(Season season) {
    switch (season) {
      case Season.spring:
        return "🌸 Spring is your time of renewal. Energy rises, your mind gets clearer. A great time to plan, create, and try new things.";
      case Season.summer:
        return "☀️ Summer is your peak power phase. You're glowing, confident, and social. Be visible, speak up, and enjoy the spotlight.";
      case Season.autumn:
        return "🍂 Autumn invites introspection. Sensitivity rises — journal, edit, and prep. Say no to what doesn’t serve you.";
      case Season.winter:
        return "❄️ Winter is for deep rest. Your body is renewing. Retreat, reflect, and honor your pace with softness.";
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  TextStyle get _sectionTitle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      );

  TextStyle get _sectionBody => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      );

  List<Color> _getColors(Season season) {
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
}
