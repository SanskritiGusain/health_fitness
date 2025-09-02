import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/plan/today_workout.dart';
import 'package:test_app/utils/circlular progressbar.dart'; // Your custom circular progress widget

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _days = [
    {"day": "Monday", "subtitle": "Upper Body"},
    {"day": "Tuesday", "subtitle": "Cardio"},
    {"day": "Wednesday", "subtitle": "Lower Body"},
    {"day": "Thursday", "subtitle": "Legs"},
    {"day": "Friday", "subtitle": "Lower Body"},
    {"day": "Sunday", "subtitle": "Rest Day"},
  ];

  int _selectedDay = 0;
  bool _allDone = false; // Track if all workouts are completed

  final _workoutPlan = [
    {
      "name": "Push-ups",
      "image": "assets/icons_update/pushup.svg",
      "sets": 3,
      "reps": "10–15",
      "rest": "60s",
      "note": "Keep the body straight",
    },
    {
      "name": "Bicep Curls",
      "image": "assets/icons_update/bicep.svg",
      "sets": 3,
      "reps": "10–15",
      "rest": "60s",
      "note": "Keep the body straight",
    },
    {
      "name": "Full Plank",
      "image": "assets/icons_update/plank.svg",
      "sets": 3,
      "duration": "30 sec",
      "rest": "60s",
      "note": "Keep the body straight",
    },
    {
      "name": "Shoulder Raises",
      "image": "assets/icons_update/shoulder.svg",
      "sets": 3,
      "reps": "10–15",
      "rest": "60s",
      "note": "Keep the body straight",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            // Calories Burned Card
            Container(
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ask Luna Container → only show if not all done
            if (!_allDone)
              Container(
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
                child: Row(
                  children: [
                 
               
                    const Expanded(
                      child: Text(
                        "💬  Ask Luna to modify or change your plan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (!_allDone) const SizedBox(height: 16),

            // Days Chips
            SizedBox(
              height: 56,
            
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final d = _days[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = index),
                    child: _dayChip(d["day"]!, d["subtitle"]!, _selectedDay == index),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Today's Plan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Workout Cards
            Column(
              children: _workoutPlan
                  .map((workout) => _workoutCard(workout, _allDone))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Buttons
           // Buttons
ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    minimumSize: const Size(double.infinity, 50),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodayWorkoutScreen(),
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
    side: const BorderSide(color: Colors.black, width: 1.5), // <-- border here
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // rounded corners
    ),
  ),
  onPressed: () {
    setState(() {
      _allDone = true; // mark all completed + hide Ask Luna
    });
  },
  child: const Text(
    "Mark as All Done",
    style: TextStyle(color: Colors.black), // black text
  ),
),

          ],
        ),
      ),
    );
  }

  // Day Chip Widget
  Widget _dayChip(String day, String subtitle, bool selected) {
    return Container(
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
            subtitle,
            style: TextStyle(
              color: selected ? Colors.white70 : Colors.black54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Workout Card Widget
// Workout Card Widget
Widget _workoutCard(Map<String, dynamic> workout, bool completed) {
  return Stack(
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SvgPicture.asset(
                workout["image"],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Sets: ${workout["sets"]}   "
                    "${workout["reps"] != null ? "Reps: ${workout["reps"]}" : "Duration: ${workout["duration"]}"}   "
                    "Rest: ${workout["rest"]}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Note: ${workout["note"]}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Top-right checkmark overlay
      if (completed)
        Positioned(
          top: 8,
          right: 8,
          child: SvgPicture.asset(
            "assets/icons_update/checkbox_checked.svg",
            height: 18,
            width: 18
          ),
        ),
    ],
  );
}

}
