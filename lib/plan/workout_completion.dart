import 'package:flutter/material.dart';
import 'package:test_app/plan/fitness_wellness.dart';

class WorkoutCompletionScreen extends StatelessWidget {
  final List<WorkoutExercise> exercises;
  
  const WorkoutCompletionScreen({
    Key? key,
    required this.exercises,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Success Icon (using built-in icon instead of asset)

               
                Image.asset(
                'assets/icons/check_circle.png',
                height: 48,
                width: 48,
              ),
              
          
              
              const SizedBox(height: 24),
              
              // Congratulations Text
              const Text(
                'Congratulations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 2),
              
              const Text(
                'Your today\'s goal is ready',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Main Workout Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout Header
                    Row(
                      children: [
                         Image.asset(
                'assets/icons/workout_icon.png',
                height: 48,
                width: 48,
              ),
                        const SizedBox(width: 12),
                        const Text(
                          'Workout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Exercise Cards
                    ...exercises.map((exercise) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16), // Added back padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(exercise.category),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  exercise.category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                exercise.details,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Go to Home Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FitnessWellnessScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Go to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'strength':
        return  Color.fromARGB(255, 215, 234, 252);
      case 'cardio':
        return  Color.fromARGB(255, 215, 234, 252);
      case 'flexibility':
        return  Color.fromARGB(255, 215, 234, 252);
      default:
        return Color.fromARGB(255, 215, 234, 252);
    }
  }
}

// Model class for workout exercises
class WorkoutExercise {
  final String name;
  final String details;
  final String category;
  
  WorkoutExercise({
    required this.name,
    required this.details,
    required this.category,
  });
}

// Example usage with sample data
class WorkoutCompletionExample extends StatelessWidget {
  const WorkoutCompletionExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sampleExercises = [
      WorkoutExercise(
        name: 'Squats',
        details: '3 sets × 15 reps',
        category: 'Strength',
      ),
      WorkoutExercise(
        name: 'Lunges (each leg)',
        details: '2 sets × 12 reps',
        category: 'Strength',
      ),
      WorkoutExercise(
        name: 'Cycling',
        details: '1 hour',
        category: 'Cardio',
      ),
      WorkoutExercise(
        name: 'Standing Forward Bend',
        details: '30 seconds hold',
        category: 'Flexibility',
      ),
    ];

    return WorkoutCompletionScreen(exercises: sampleExercises);
  }
}