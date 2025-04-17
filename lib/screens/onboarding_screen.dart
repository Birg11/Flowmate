import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/settings_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;
  DateTime? _cycleStartDate;

  void _nextPage() {
    if (_pageIndex < 2) {
      setState(() => _pageIndex++);
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutExpo,
      );
    } else {
      SettingsService.cycleStartDate = _cycleStartDate;
      SettingsService.onboardingComplete = true;
      context.goNamed('home');
    }
  }

  void _prevPage() {
    if (_pageIndex > 0) {
      setState(() => _pageIndex--);
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutExpo,
      );
    }
  }

  Widget _buildStepContent() {
    switch (_pageIndex) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "🌸 Welcome to FlowMate",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "FlowMate helps you understand your cycle with seasonal wisdom.\n\nGentle. Intuitive. You-focused.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        );
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "📅 When did your last period begin?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  initialDate: _cycleStartDate ?? DateTime.now(),
                );
                if (date != null) setState(() => _cycleStartDate = date);
              },
              label: Text(
                _cycleStartDate == null
                    ? "Select Date"
                    : "Selected: ${_cycleStartDate!.toLocal().toString().split(' ')[0]}",
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "This helps us personalize your experience 💜",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "✨ You're Ready!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "• Cycle Start: ${_cycleStartDate?.toLocal().toString().split(' ')[0] ?? 'Not selected'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "We’ll guide you gently, season by season.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              "Tap 'Finish' to enter your FlowMate dashboard 🌼",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final selected = index == _pageIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: selected ? 12 : 8,
          height: selected ? 12 : 8,
          decoration: BoxDecoration(
            color: selected
                ? Colors.deepPurple
                : Colors.deepPurple.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _pageIndex == 2;
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (_, __) => _buildStepContent(),
                ),
              ),
              const SizedBox(height: 12),
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_pageIndex > 0)
                    TextButton(
                      onPressed: _prevPage,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                      child: const Text("Back"),
                    ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(isLast ? "Finish" : "Next"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
