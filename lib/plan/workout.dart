import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutPlan = [
      {
        "name": "Push-ups",
        "image": "assets/images/pushup.png",
        "sets": 3,
        "reps": "10–15",
        "rest": "60s",
        "note": "Keep the body straight",
      },
      {
        "name": "Bicep Curls",
        "image": "assets/images/bicep.png",
        "sets": 3,
        "reps": "10–15",
        "rest": "60s",
        "note": "Keep the body straight",
      },
      {
        "name": "Full Plank",
        "image": "assets/images/plank.png",
        "sets": 3,
        "duration": "30 sec",
        "rest": "60s",
        "note": "Keep the body straight",
      },
      {
        "name": "Shoulder Raises",
        "image": "assets/images/shoulder.png",
        "sets": 3,
        "reps": "10–15",
        "rest": "60s",
        "note": "Keep the body straight",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calories Burned Circular Progress
            Center(
              child: SizedBox(
                height: 140,
                width: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0.6,
                      strokeWidth: 8,
                      color: Colors.orange,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "400 Kcal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text("Remaining", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Ask Luna button
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Ask Luna to modify or change your plan",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Days Selector
            Row(
              children: [
                _dayChip("Monday", "Upper Body", true),
                const SizedBox(width: 8),
                _dayChip("Tuesday", "Cardio", false),
                const SizedBox(width: 8),
                _dayChip("Wednesday", "Lower Body", false),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              "Today's Plan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Workout list
            Column(
              children:
                  workoutPlan.map((workout) {
                    return _workoutCard(workout);
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Buttons
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Workout"),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text("Mark as All Done"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayChip(String day, String subtitle, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: selected ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _workoutCard(Map<String, dynamic> workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
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
    );
  }
}
