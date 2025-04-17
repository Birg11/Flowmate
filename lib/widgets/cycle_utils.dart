int calculateCycleDay(DateTime? start, DateTime date) {
  if (start == null) return 1;

  final startDate = DateTime(start.year, start.month, start.day);
  final targetDate = DateTime(date.year, date.month, date.day);
  final diff = targetDate.difference(startDate).inDays;

  return ((diff % 28) + 28) % 28 + 1; // Wrap for both future and past cycles
}
