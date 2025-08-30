import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/pages/congratulation.dart';
import 'package:test_app/plan/workout_completion.dart';

class FitnessGoalLoadingScreen extends StatefulWidget {
  const FitnessGoalLoadingScreen({Key? key}) : super(key: key);

  @override
  State<FitnessGoalLoadingScreen> createState() =>
      _FitnessGoalLoadingScreenState();
}

class _FitnessGoalLoadingScreenState extends State<FitnessGoalLoadingScreen> {
  double progress = 0.01;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startProgressAnimation();
  }

  void startProgressAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          // Replace with your actual navigation
          // In your FitnessGoalLoadingScreen, replace the navigation with:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CongratulationsScreen()),
          );
        });
      } else {
        setState(() {
          progress += 0.01;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              // Animated Percentage
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  final percentage = (value * 100).toInt();
                  return Text(
                    "$percentage%",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              const Text(
                "We’re setting your personalized plan according to your preference ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFE0B2), Color(0xFF00695C)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Plan Preference",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildGoalRow("Almost Done", progress >= 1.0),
                    buildGoalRow("Dietary Preferences", progress >= 0.75),
                    buildGoalRow("Workout Preferences", progress >= 0.50),
                    buildGoalRow("Target Weight", progress >= 0.25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGoalRow(String title, bool isCompleted) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: isCompleted ? 1 : 0, end: isCompleted ? 1 : 0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      title == "Basic Options"
                          ? FontWeight.w600
                          : FontWeight.normal,
                  color: isCompleted ? Colors.black : Colors.grey[600],
                ),
              ),
              AnimatedSlide(
                offset: isCompleted ? Offset(0, 0) : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: isCompleted ? 1.0 : 0.0,
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
