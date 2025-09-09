import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/utils/custom_app_bars.dart';
import 'dart:async';

class TodayWorkoutScreen extends StatefulWidget {
  final List<dynamic> todayPlan;

  const TodayWorkoutScreen({super.key, required this.todayPlan});

  @override
  State<TodayWorkoutScreen> createState() => _TodayWorkoutScreenState();
}

class _TodayWorkoutScreenState extends State<TodayWorkoutScreen> {
  int selectedDayIndex = 0;
  int currentExerciseIndex = 0;

  Timer? _workoutTimer;
  Timer? _restTimer;
  int workoutSeconds = 0;
  int restSeconds = 60;
  bool isResting = false;
  bool isWorkoutPaused = false;
  bool isRestPaused = false;

  @override
  void initState() {
    super.initState();
    _startWorkoutTimer();
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _startWorkoutTimer() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isWorkoutPaused && !isResting) {
        setState(() {
          workoutSeconds++;
        });
      }
    });
  }

  void _startRestTimer() {
    final currentExercise = widget.todayPlan[currentExerciseIndex];
    int rest = 60;
    if (currentExercise["rest"] != null) {
      final restStr = currentExercise["rest"].toString().toLowerCase();
      rest = int.tryParse(restStr.replaceAll(RegExp(r'[^0-9]'), "")) ?? 60;
    }

    setState(() {
      isResting = true;
      restSeconds = rest;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRestPaused) {
        setState(() {
          restSeconds--;
        });
        if (restSeconds <= 0) {
          _restTimer?.cancel();
          _nextExercise();
        }
      }
    });
  }

  void _pauseTimers() {
    setState(() {
      if (isResting) {
        isRestPaused = !isRestPaused;
      } else {
        isWorkoutPaused = !isWorkoutPaused;
      }
    });
  }

  void _resetWorkout() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF8FBFB),
          title: const Text(
            'Reset Workout',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to reset and go back? All progress will be lost.',
            style: TextStyle(fontSize: 14, color: Colors.black38),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  void _nextExercise() {
    final totalExercises = widget.todayPlan.length;

    if (currentExerciseIndex < totalExercises - 1) {
      setState(() {
        currentExerciseIndex++;
        isResting = false;
        isRestPaused = false;
      });
      _restTimer?.cancel();
    } else {
      setState(() {
        currentExerciseIndex = totalExercises;
      });
      _workoutTimer?.cancel();
      _restTimer?.cancel();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final todayPlan = widget.todayPlan;
    bool isWorkoutCompleted = currentExerciseIndex >= todayPlan.length;

    return Scaffold(
      appBar: CustomAppBars.backAppBar(context, "Today's Workout"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWorkoutCompleted)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons_update/checkbox_checked.svg",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Workout Completed! 🎉",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Great job! You've completed today's workout in ${_formatTime(workoutSeconds)}.\nKeep up the momentum!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )
            else
              _buildTimerContainer(todayPlan),

            const SizedBox(height: 16),
            const Text(
              "Workout Plan:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children:
                  todayPlan.asMap().entries.map<Widget>((entry) {
                    int index = entry.key;
                    Map<String, dynamic> workout = entry.value;
                    return _workoutCard(
                      workout,
                      isCurrentExercise:
                          index == currentExerciseIndex &&
                          !isResting &&
                          !isWorkoutCompleted,
                      isCompleted:
                          index < currentExerciseIndex || isWorkoutCompleted,
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerContainer(List todayPlan) {
    final currentExercise = todayPlan[currentExerciseIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 235, 234, 234),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ Show workout timer OR rest timer
          if (isResting) ...[
            Text(
              _formatTime(workoutSeconds),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Rest Time:",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTime(restSeconds),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              _formatTime(workoutSeconds),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              "Exercise ${currentExerciseIndex + 1} of ${todayPlan.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _pauseTimers,
                icon: Icon(
                  (isResting ? isRestPaused : isWorkoutPaused)
                      ? Icons.play_arrow
                      : Icons.pause,
                ),
                label: Text(
                  (isResting ? isRestPaused : isWorkoutPaused)
                      ? "Resume"
                      : "Pause",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _resetWorkout,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              if (!isResting) ...[
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (currentExerciseIndex < todayPlan.length - 1) {
                      _startRestTimer();
                    } else {
                      _nextExercise();
                    }
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text("Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _workoutCard(
    Map<String, dynamic> workout, {
    bool isCurrentExercise = false,
    bool isCompleted = false,
  }) {
    // Null-safe fields
    final image = workout["image"] ?? "assets/icons_update/plank.svg";
    final name = workout["name"] ?? "Unnamed Exercise";
    final sets = workout["sets"]?.toString() ?? "-";
    final reps =
        workout["reps"]?.toString() ?? workout["duration"]?.toString() ?? "-";
    final rest = workout["rest"]?.toString() ?? "-";
    final note = workout["note"] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentExercise ? Color(0xFFE6F3FF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCompleted ? Border.all(color: Colors.green, width: 2) : null,
        // ✅ Add shadow for current exercise
        boxShadow:
            isCurrentExercise
                ? [
                  BoxShadow(
                    color: Color(0xFFE6F3FF),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SvgPicture.asset(
              image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (isCompleted)
                      SvgPicture.asset(
                        'assets/icons_update/tabler_checkbox.svg',
                        color: Colors.green,
                        width: 22,
                        height: 22,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Sets: $sets   Reps/Duration: $reps   Rest: $rest",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                if (note.isNotEmpty)
                  Text(
                    "Note: $note",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
