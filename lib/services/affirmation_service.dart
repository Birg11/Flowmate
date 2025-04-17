
class AffirmationService {
  static final List<String> _affirmations = [
    "You are in sync with your cycle.",
    "You honor your body's rhythm.",
    "You are grounded and powerful.",
    "You are blooming, just like Spring.",
    "Rest is not laziness — it is wisdom.",
    "Your energy is sacred.",
    "Every phase is a gift.",
    "You are healing with every breath.",
    "You trust your body's wisdom.",
  ];

  static String getDailyAffirmation() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final index = dayOfYear % _affirmations.length;
    return _affirmations[index];
  }
}
