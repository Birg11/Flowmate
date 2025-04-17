import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/log_service.dart';
import '../theme/seasonal_colors.dart';
import '../services/settings_service.dart';

class LogScreen extends StatefulWidget {
  final DateTime date;
  const LogScreen({super.key, required this.date});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  String? mood;
  String? flow;
  String? note;

  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final log = LogService().getLog(widget.date);
    print("🚨 Current log for ${widget.date.toLocal()}: $log");

    mood = log?['mood'];
    note = log?['note'];
    _noteController.text = note ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (log?['flow'] != null) {
        setState(() => flow = log!['flow']);
        print("✅ Found saved flow: ${log?['flow']}");
      } else {
        final start = SettingsService.cycleStartDate;
        if (start != null) {
final diff = widget.date.difference(start).inDays;
final day = ((diff % 28) + 28) % 28 + 1;
          String estimated;
          if (day <= 1) estimated = "Heavy";
          else if (day <= 3) estimated = "Medium";
          else if (day <= 5) estimated = "Light";
          else estimated = "None";

          print("📌 Estimated flow for Day $day: $estimated");
          setState(() => flow = estimated);
        }
      }
    });
  }

  String getPrompt() {
    final start = SettingsService.cycleStartDate;
    if (start == null) return "How are you feeling today?";
    final days = widget.date.difference(start).inDays % 28;

    if (days <= 5) return "What’s one thing you need today to rest fully?";
    if (days <= 13) return "What’s exciting you right now?";
    if (days <= 17) return "What are you ready to express or share?";
    return "What are you letting go of lately?";
  }

  Future<void> _save() async {
    if (flow == null || flow!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a flow intensity.")),
      );
      return;
    }

    final data = {
      'date': widget.date.toIso8601String(),
      'mood': mood,
      'flow': flow,
      'note': _noteController.text.trim(),
    };

    print("💾 Saving log data: $data");

    await LogService().saveLog(widget.date, data);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = SeasonalColors.spring;

    return Scaffold(
      appBar: AppBar(title: const Text("Log Today")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Date: ${widget.date.toLocal().toString().split(' ')[0]}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: mood,
              decoration: const InputDecoration(labelText: 'Mood'),
              items: ['😊', '😐', '😢', '😡', '😴']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) => setState(() => mood = val),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: flow,
              decoration: const InputDecoration(labelText: 'Flow Intensity'),
              items: ['None', 'Light', 'Medium', 'Heavy']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (val) => setState(() => flow = val),
            ),

            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("📝 Prompt of the Day", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.first.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(getPrompt(), style: GoogleFonts.poppins(fontSize: 15)),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _noteController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your thoughts...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text("Save Entry"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
