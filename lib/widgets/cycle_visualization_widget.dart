import 'dart:math';
import 'package:flutter/material.dart';

class CycleVisualizationWidget extends StatelessWidget {
  final int currentDay;

  const CycleVisualizationWidget({
    super.key,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(240, 240),
      painter: SolidCyclePainter(),
    );
  }
}

class SolidCyclePainter extends CustomPainter {
  final List<Map<String, dynamic>> segments = [
    {'label': 'Winter', 'range': 5, 'color': Colors.indigo, 'startDay': 1},
    {'label': 'Spring', 'range': 8, 'color': Colors.green, 'startDay': 6},
    {'label': 'Summer', 'range': 4, 'color': Colors.orange, 'startDay': 14},
    {'label': 'Autumn', 'range': 11, 'color': Colors.brown, 'startDay': 18},
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    double startAngle = -pi / 2; // Start at top

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (var seg in segments) {
      final sweepAngle = (seg['range'] as int) * (2 * pi / 28);
      final paint = Paint()..color = (seg['color'] as Color).withOpacity(0.9);

      // Draw the pie slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Label position
      final labelAngle = startAngle + sweepAngle / 2;
      final offset = Offset(
        center.dx + cos(labelAngle) * radius * 0.55,
        center.dy + sin(labelAngle) * radius * 0.55,
      );

      final label = seg['label'];
      final start = seg['startDay'];
      final end = start + seg['range'] - 1;
      final fullLabel = "$label\n$start–$end";

      textPainter.text = TextSpan(
        text: fullLabel,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
