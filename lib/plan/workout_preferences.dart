import 'package:flutter/material.dart';
import 'package:test_app/plan/diet_preferences.dart';

class WorkoutPreferences extends StatefulWidget {
  const WorkoutPreferences({Key? key}) : super(key: key);

  @override
  State<WorkoutPreferences> createState() => _WorkoutPreferencesState();
}

class _WorkoutPreferencesState extends State<WorkoutPreferences> {
  String selectedLevel = '';
  List<String> selectedWorkoutTypes = [];
  String selectedTimeAvailability = '';
  List<String> selectedSpecialNeeds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fitness Flow',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Level',
                    children: [_buildLevelOptions()],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Workout Type',
                    children: [_buildWorkoutTypeOptions()],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Time Availability',
                    children: [_buildTimeAvailabilityOptions()],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Special Needs / Conditions',
                    children: [_buildSpecialNeedsOptions()],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DietPreferencesScreen(),
                    ),
                  );
                  // Handle next button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildLevelOptions() {
    return Row(
      children: [
        _buildSelectableChip(
          text: 'Beginner',
          isSelected: selectedLevel == 'Beginner',
          onTap: () => setState(() => selectedLevel = 'Beginner'),
        ),
        const SizedBox(width: 12),
        _buildSelectableChip(
          text: 'Intermediate',
          isSelected: selectedLevel == 'Intermediate',
          onTap: () => setState(() => selectedLevel = 'Intermediate'),
        ),
        const SizedBox(width: 12),
        _buildSelectableChip(
          text: 'Advanced',
          isSelected: selectedLevel == 'Advanced',
          onTap: () => setState(() => selectedLevel = 'Advanced'),
        ),
      ],
    );
  }

  Widget _buildWorkoutTypeOptions() {
    return Column(
      children: [
        Row(
          children: [
            _buildSelectableChip(
              text: 'Home Workouts',
              isSelected: selectedWorkoutTypes.contains('Home Workouts'),
              onTap: () => _toggleWorkoutType('Home Workouts'),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: 'Gym Workouts',
              isSelected: selectedWorkoutTypes.contains('Gym Workouts'),
              onTap: () => _toggleWorkoutType('Gym Workouts'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSelectableChip(
              text: 'Yoga & Stretching',
              isSelected: selectedWorkoutTypes.contains('Yoga & Stretching'),
              onTap: () => _toggleWorkoutType('Yoga & Stretching'),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: 'Pilates',
              isSelected: selectedWorkoutTypes.contains('Pilates'),
              onTap: () => _toggleWorkoutType('Pilates'),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: 'Cardio',
              isSelected: selectedWorkoutTypes.contains('Cardio'),
              onTap: () => _toggleWorkoutType('Cardio'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSelectableChip(
              text: 'Strength Training',
              isSelected: selectedWorkoutTypes.contains('Strength Training'),
              onTap: () => _toggleWorkoutType('Strength Training'),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: 'Dance Workouts',
              isSelected: selectedWorkoutTypes.contains('Dance Workouts'),
              onTap: () => _toggleWorkoutType('Dance Workouts'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeAvailabilityOptions() {
    return Column(
      children: [
        Row(
          children: [
            _buildSelectableChip(
              text: 'Under 15 minutes',
              isSelected: selectedTimeAvailability == 'Under 15 minutes',
              onTap:
                  () => setState(
                    () => selectedTimeAvailability = 'Under 15 minutes',
                  ),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: '15-30 minutes',
              isSelected: selectedTimeAvailability == '15-30 minutes',
              onTap:
                  () => setState(
                    () => selectedTimeAvailability = '15-30 minutes',
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSelectableChip(
              text: '30-45 minutes',
              isSelected: selectedTimeAvailability == '30-45 minutes',
              onTap:
                  () => setState(
                    () => selectedTimeAvailability = '30-45 minutes',
                  ),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: '45+ minutes',
              isSelected: selectedTimeAvailability == '45+ minutes',
              onTap:
                  () =>
                      setState(() => selectedTimeAvailability = '45+ minutes'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecialNeedsOptions() {
    return Column(
      children: [
        Row(
          children: [
            _buildSelectableChip(
              text: 'Low impact / Joint-friendly',
              isSelected: selectedSpecialNeeds.contains(
                'Low impact / Joint-friendly',
              ),
              onTap: () => _toggleSpecialNeed('Low impact / Joint-friendly'),
            ),
            const SizedBox(width: 12),
            _buildSelectableChip(
              text: 'Senior-friendly',
              isSelected: selectedSpecialNeeds.contains('Senior-friendly'),
              onTap: () => _toggleSpecialNeed('Senior-friendly'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSelectableChip(
              text: 'Postnatal / Prenatal',
              isSelected: selectedSpecialNeeds.contains('Postnatal / Prenatal'),
              onTap: () => _toggleSpecialNeed('Postnatal / Prenatal'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectableChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _toggleWorkoutType(String workoutType) {
    setState(() {
      if (selectedWorkoutTypes.contains(workoutType)) {
        selectedWorkoutTypes.remove(workoutType);
      } else {
        selectedWorkoutTypes.add(workoutType);
      }
    });
  }

  void _toggleSpecialNeed(String specialNeed) {
    setState(() {
      if (selectedSpecialNeeds.contains(specialNeed)) {
        selectedSpecialNeeds.remove(specialNeed);
      } else {
        selectedSpecialNeeds.add(specialNeed);
      }
    });
  }
}
