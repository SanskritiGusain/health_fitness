import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/utils/custom_app_bars.dart';
import 'package:test_app/utils/circlular progressbar.dart';
import 'package:test_app/plan/today_workout.dart';
import 'dart:async';

class TodayWorkoutScreen extends StatefulWidget {
  const TodayWorkoutScreen({super.key});

  @override
  State<TodayWorkoutScreen> createState() => _TodayWorkoutScreenState();
}

class _TodayWorkoutScreenState extends State<TodayWorkoutScreen> {
  int selectedDayIndex = 0;
  int currentExerciseIndex = 0;

  // Timer variables
  Timer? _workoutTimer;
  Timer? _restTimer;
  int workoutSeconds = 0;
  int restSeconds = 60;
  bool isResting = false;
  bool isWorkoutPaused = false;
  bool isRestPaused = false;

  // Day → Workouts mapping
  final List<Map<String, dynamic>> workoutSchedule = [
    {
      "plan": [
        {
          "name": "Push-ups",
          "image": "assets/images_update/pushup.svg",
          "sets": 3,
          "reps": "10–15",
          "rest": "60s",
          "note": "Keep the body straight",
        },
        {
          "name": "Bicep Curls",
          "image": "assets/images_update/bicep.svg",
          "sets": 3,
          "reps": "10–15",
          "rest": "60s",
          "note": "Keep elbows tucked",
        },
        {
          "name": "Full Plank",
          "image": "assets/images_update/plank.svg",
          "sets": 3,
          "reps": "10–15",
          "rest": "60s",
          "note": "Keep elbows tucked",
        },
        {
          "name": "Shoulder Raises",
          "image": "assets/images_update/shoulder.svg",
          "sets": 3,
          "reps": "10–15",
          "rest": "60s",
          "note": "Keep elbows tucked",
        },
      ],
    },
  ];

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
    setState(() {
      isResting = true;
      restSeconds = 60;
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
    // Cancel all timers
    _workoutTimer?.cancel();
    _restTimer?.cancel();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200, // Dialog background
          title: const Text(
            'Reset Workout',
            style: TextStyle(color: Colors.black), // Title color
          ),
          content: const Text(
            'Are you sure you want to reset and go back? All progress will be lost.',
            style: TextStyle(fontSize: 14, color: Colors.black38), // Text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white, // Button background
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black, // Button background
              ),
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
        );
      },
    );
  }


  void _nextExercise() {
    final totalExercises = workoutSchedule[selectedDayIndex]["plan"].length;

    if (currentExerciseIndex < totalExercises - 1) {
      setState(() {
        currentExerciseIndex++;
        isResting = false;
        isRestPaused = false;
      });
      _restTimer?.cancel();
    } else {
      // Workout completed
      _workoutTimer?.cancel();
      _restTimer?.cancel();
      _showWorkoutCompleteDialog();
    }
  }

  void _showWorkoutCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Complete!'),
          content: Text(
            'Great job! You completed your workout in ${_formatTime(workoutSeconds)}.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final todayPlan = workoutSchedule[selectedDayIndex]["plan"];
    final currentExercise = todayPlan[currentExerciseIndex];

    return Scaffold(
      appBar: CustomAppBars.backAppBar(context, "Today's Workout"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer Container
            Container(
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
                  // Dual Timer Display
                  if (isResting) ...[
                
                    
                 
                     
                        Text(
                          " ${_formatTime(workoutSeconds)}",
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                          "Rest Time:",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(restSeconds),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                          ],
                         )
                   
                  ] else ...[
                    // Workout Timer (Primary)
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
                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pause/Resume Button
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
                      // Reset Button
                      ElevatedButton.icon(
                        onPressed: _resetWorkout,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reset"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      // Next Button
                  isResting
                          ? SizedBox.shrink() // Empty widget when resting
                          : ElevatedButton.icon(
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Current Exercise Highlight
         
            // All Exercises List
            Text(
              "Workout Plan:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          index == currentExerciseIndex && !isResting,
                      isCompleted: index < currentExerciseIndex,
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _workoutCard(
    Map<String, dynamic> workout, {
    bool isCurrentExercise = false,
    bool isCompleted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isCurrentExercise
                ? Colors.grey.shade300
                : isCompleted
                ? Colors.grey.shade100
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border:
            isCurrentExercise
                ? Border.all(color: Colors.transparent, width: 0)
                : isCompleted
                ? Border.all(color: Colors.green, width: 2)
                : null,   
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SvgPicture.asset(
                  workout["image"],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              
               
            ],
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
                        workout["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:  Colors.black,
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
                  "Sets: ${workout["sets"] ?? "-"}   "
                  "${workout["reps"] != null ? "Reps: ${workout["reps"]}" : "Duration: ${workout["duration"] ?? "-"}"}   "
                  "Rest: ${workout["rest"] ?? "-"}",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  "Note: ${workout["note"] ?? ""}",
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
