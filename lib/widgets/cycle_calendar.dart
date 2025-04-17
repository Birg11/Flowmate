import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cycle Calendar')),
      body: const Center(
        child: Text("📅 Calendar View with Seasonal Overlay Coming Soon"),
      ),
    );
  }
}
