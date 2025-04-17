import 'package:flowmate/services/cycle_start_provider.dart';
import 'package:flowmate/services/whatsapp_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowmate/theme/app_theme.dart';
import 'package:flowmate/theme/theme_provider.dart';
import 'package:flowmate/services/settings_service.dart';
import 'package:flowmate/services/stealth_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    final stealth = ref.watch(stealthModeProvider);
    final stealthNotifier = ref.read(stealthModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ✅ NOTIFICATIONS
//      SwitchListTile(
//   title: const Text("🔔 Smart Notifications"),
//   value: SettingsService.notificationsEnabled,
//   onChanged: (val) async {
//     SettingsService.notificationsEnabled = val;

//     if (val) {
//       await NotificationService.scheduleDaily(
//         'daily_mood_prompt',
//         9,
//         0,
//         'How are you feeling today?',
//         'Take a moment to check in with your body 💖',
//       );
//     } else {
//       await NotificationService.cancelAll();
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Notifications ${val ? 'enabled' : 'disabled'}")),
//     );
//   },
// ),

TextField(
  decoration: const InputDecoration(labelText: 'Companion WhatsApp Number'),
  keyboardType: TextInputType.phone,
  onSubmitted: (value) {
    SettingsService.companionNumber = value;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact saved")),
    );
  },
),
ListTile(
  title: const Text("💬 Send Update"),
  subtitle: Text(SettingsService.companionNumber ?? 'No number set'),
  onTap: () async {
    final number = SettingsService.companionNumber;
    if (number != null) {
      final msg = "Hey 💕 Just a quick check-in: I'm in my Winter phase today. Might need a little extra rest and kindness.";
      await WhatsAppService.sendMessage(number, msg);
    }
  },
),

          // ✅ STEALTH MODE
          SwitchListTile(
            title: const Text("🔐 Stealth Mode"),
            value: stealth,
            onChanged: (val) => stealthNotifier.state = val,
          ),

          // ✅ CYCLE DATE MODAL
          ListTile(
            title: const Text("🩸 Edit Cycle Start Date"),
            subtitle: Text(
              SettingsService.cycleStartDate != null
                  ? SettingsService.cycleStartDate!.toLocal().toString().split(' ')[0]
                  : "Not set",
            ),
          onTap: () async {
  final picked = await showDatePicker(
    context: context,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now(),
    initialDate: SettingsService.cycleStartDate ?? DateTime.now(),
  );
  if (picked != null) {
    SettingsService.cycleStartDate = picked;

    // ✅ Add this to notify other screens
    ref.invalidate(cycleStartProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cycle date set to ${picked.toLocal().toString().split(' ')[0]}")),
    );
  }
},

          ),

          const Divider(),

          // ✅ THEME
          ListTile(
            title: const Text("🎨 App Theme"),
            trailing: DropdownButton<FlowThemeMode>(
              value: mode,
              onChanged: (val) => themeNotifier.setTheme(val!),
              items: FlowThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.name.toUpperCase()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      
    );
    
  }
}
