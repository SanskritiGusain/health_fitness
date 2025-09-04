import 'package:flutter/material.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/pages/congratulation.dart';
import 'package:test_app/pages/transformation.dart';
import 'package:test_app/plan/fitness_goal_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/shared_preferences.dart' as userApi;


class DietPreferencesScreen extends StatefulWidget {
  const DietPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<DietPreferencesScreen> createState() => _DietPreferencesScreenState();
}

class _DietPreferencesScreenState extends State<DietPreferencesScreen> {
  String selectedLevel = '';
  List<String> selectedWorkoutTypes = [];
  List<String> selectedAllergies = []; // Changed to support multiple selections
  List<String> selectedSpecialNeeds = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // ✅ Load saved prefs on screen open
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final savedLevels = prefs.getStringList("diet_level") ?? [];
    selectedLevel = savedLevels.isNotEmpty ? savedLevels.first : "";

    selectedWorkoutTypes = prefs.getStringList("diet_goal_options") ?? [];
    selectedAllergies = prefs.getStringList("diet_allergies") ?? [];
    selectedSpecialNeeds = prefs.getStringList("diet_special_needs") ?? [];

    print("📂 Loaded Diet Preferences:");
    print("Level: $selectedLevel");
    print("Goals: $selectedWorkoutTypes");
    print("Allergies: $selectedAllergies");
    print("Special Needs: $selectedSpecialNeeds");

    setState(() {});
  }
bool _isButtonEnabled = true;
Future<void> _submitAll() async {
    setState(() => _isButtonEnabled = false);

    try {
      // ✅ Save diet preferences before sending
      await _savePreferences();

      // ✅ Collect everything from SharedPreferences
      final body = await userApi.PersistentData.getAllPersistentData();
  
      // 🖥️ Debug log
      print("📤 API Request Body (user/): $body");

      // ✅ API call
      final response = await ApiService.putRequest("user/", body);

      // 🖥️ Debug log response
      print("✅ API Response: $response");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All data saved successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  FitnessGoalLoadingScreen()),
      );
    }  catch (e) {
      print("🔥 Exception in submit: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send data.")));
    } finally {
      setState(() => _isButtonEnabled = true);
    }
  }


   Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Save level (single string, so wrap it into a list if you want array-style)
    if (selectedLevel.isNotEmpty) {
      await prefs.setStringList("diet_level", [selectedLevel]);
    }

    // Save as arrays
    await prefs.setStringList("diet_goal_options", selectedWorkoutTypes);
    await prefs.setStringList("diet_allergies", selectedAllergies);
    await prefs.setStringList("diet_special_needs", selectedSpecialNeeds);

    print("✅ Saved Diet Preferences:");
    print("Level: $selectedLevel");
    print("Goals: $selectedWorkoutTypes");
    print("Allergies: $selectedAllergies");
    print("Special Needs: $selectedSpecialNeeds");
  }

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
          'Dietary Preferences',
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
                    title: 'Basic Options',
                    children: [_buildLevelOptions()],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Goal Based Options',
                    children: [_buildWorkoutTypeOptions()],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Allergy / Avoidance',
                    children: [_buildAllergyOptions()],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Other Specific Choices',
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
onPressed: _isButtonEnabled ? _submitAll : null,


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
    final options = ['Beginner', 'Intermediate', 'Advanced'];
    return _buildResponsiveChipGrid(
      options: options,
      selectedItems: selectedLevel.isEmpty ? [] : [selectedLevel],
      onToggle: (option) => setState(() => selectedLevel = option),
      allowMultiple: false,
    );
  }

  Widget _buildWorkoutTypeOptions() {
    final options = [
      'High Protein',
      'Low Carb / Keto',
      'Low Fat',
      'Balanced Diet',
      'High Fiber',
      'Strength Training',
      'Dance Workouts',
    ];
    return _buildResponsiveChipGrid(
      options: options,
      selectedItems: selectedWorkoutTypes,
      onToggle: _toggleWorkoutType,
      allowMultiple: true,
    );
  }

  Widget _buildAllergyOptions() {
    final options = ['Lactose-Free', 'Nut-Free', 'Soy-Free', 'Gluten-Free'];
    return _buildResponsiveChipGrid(
      options: options,
      selectedItems: selectedAllergies,
      onToggle: _toggleAllergy,
      allowMultiple: true,
    );
  }

  Widget _buildSpecialNeedsOptions() {
    final options = [
      'PCOS-Friendly',
      'Menopause supportive',
      'Diabetic Friendly',
      'Low Sodium',
    ];
    return _buildResponsiveChipGrid(
      options: options,
      selectedItems: selectedSpecialNeeds,
      onToggle: _toggleSpecialNeed,
      allowMultiple: true,
    );
  }

  Widget _buildResponsiveChipGrid({
    required List<String> options,
    required List<String> selectedItems,
    required Function(String) onToggle,
    required bool allowMultiple,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              options.map((option) {
                final isSelected = selectedItems.contains(option);
                return _buildSelectableChip(
                  text: option,
                  isSelected: isSelected,
                  onTap: () => onToggle(option),
                  maxWidth: constraints.maxWidth,
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildSelectableChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required double maxWidth,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate chip width based on text length and available space
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Add padding to the text width
        final chipWidth = textPainter.width + 32; // 16px padding on each side
        final availableWidth = maxWidth;

        // Ensure chip doesn't exceed available width
        final finalWidth =
            chipWidth > availableWidth ? availableWidth : chipWidth;

        return SizedBox(
          width: finalWidth,
          child: GestureDetector(
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
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        );
      },
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

  void _toggleAllergy(String allergy) {
    setState(() {
      if (selectedAllergies.contains(allergy)) {
        selectedAllergies.remove(allergy);
      } else {
        selectedAllergies.add(allergy);
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
