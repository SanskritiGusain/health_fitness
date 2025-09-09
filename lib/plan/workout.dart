import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/plan/today_workout.dart';
import 'package:test_app/utils/circlular progressbar.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Map<String, dynamic>? workoutData;
  bool isLoading = false;
  String? errorMessage;

  List<String> dayKeys = [];
  int _selectedDayIndex = 0;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutData();
  }

  Future<void> _fetchWorkoutData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await ApiService.getRequest('user/');
      final data = response['current_workout'] as Map<String, dynamic>?;

      if (data != null && data['weekly_schedule'] != null) {
        final schedule = data['weekly_schedule'] as Map<String, dynamic>;
        final orderedDays = [
          "monday",
          "tuesday",
          "wednesday",
          "thursday",
          "friday",
          "saturday",
          "sunday",
        ];
        final sortedKeys =
            orderedDays.where((d) => schedule.containsKey(d)).toList();

        setState(() {
          workoutData = schedule;
          dayKeys = sortedKeys;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "No workout data found.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    if (workoutData == null) {
      return const Scaffold(
        body: Center(child: Text("No workout plan available.")),
      );
    }

    final selectedDayKey = dayKeys[_selectedDayIndex];
    final selectedDayData =
        (workoutData![selectedDayKey] as Map<String, dynamic>?) ?? {};
    final exercises = (selectedDayData['exercises'] as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _caloriesCard(),

            if (!_allDone) const SizedBox(height: 16),
            if (!_allDone) _askLuna(),

            const SizedBox(height: 16),

            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dayKeys.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final key = dayKeys[index];
                  final d = (workoutData![key] as Map<String, dynamic>?) ?? {};
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = index),
                    child: _dayChip(
                      key.toUpperCase(),
                      d['type']?.toString() ?? "No Type",
                      _selectedDayIndex == index,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "${selectedDayKey[0].toUpperCase()}${selectedDayKey.substring(1)} Plan",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            if (exercises.isEmpty)
              const Text("Rest Day – No exercises today")
            else
              Column(
                children:
                    exercises
                        .map(
                          (w) => _workoutCard(
                            (w as Map<String, dynamic>?) ?? {},
                            _allDone,
                          ),
                        )
                        .toList(),
              ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed:
                  exercises.isEmpty
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    TodayWorkoutScreen(todayPlan: exercises),
                          ),
                        );
                      },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Workout"),
            ),

            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.black, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  _allDone = true;
                });
              },
              child: const Text(
                "Mark as All Done",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _caloriesCard() => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 2),
          child: Text(
            "Calories Burned",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 115,
            height: 115,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RoundedCircularProgress(
                  progress: 0.6,
                  remainingText: "",
                  strokeWidth: 9,
                  progressColor: Colors.orange,
                  backgroundColor: Colors.grey.shade300,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "400 Kcal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Remaining",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _askLuna() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE3F8B6), Color(0xFFB2F8F4)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      "💬 Ask Luna to modify or change your plan",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  );

  Widget _dayChip(String day, String? subtitle, bool selected) => Container(
    width: 148,
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: selected ? Colors.black : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Text(
          subtitle ?? "No Type",
          style: TextStyle(
            color: selected ? Colors.white70 : Colors.black54,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );

  Widget _workoutCard(Map<String, dynamic> workout, bool completed) {
    final name = workout["name"]?.toString() ?? "Unnamed Exercise";
    final sets = workout["sets"]?.toString() ?? "-";
    final reps = workout["reps"]?.toString() ?? "-";
    final rest = workout["rest"]?.toString() ?? "-";
    final instructions = workout["instructions"]?.toString() ?? "";
    final imagePath =
        (workout["image"] is String) ? workout["image"] as String : null;

    Widget imageWidget;
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith("http")) {
        imageWidget =
            imagePath.endsWith(".svg")
                ? SvgPicture.network(imagePath, fit: BoxFit.contain)
                : Image.network(imagePath, fit: BoxFit.contain);
      } else {
        imageWidget =
            imagePath.endsWith(".svg")
                ? SvgPicture.asset(imagePath, fit: BoxFit.contain)
                : Image.asset(imagePath, fit: BoxFit.contain);
      }
    } else {
      imageWidget = SvgPicture.asset(
        "assets/icons_update/plank.svg",
        fit: BoxFit.contain,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.white,
              child: imageWidget,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Sets: $sets   Reps: $reps   Rest: $rest",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  instructions.isNotEmpty ? instructions : "No instructions",
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
