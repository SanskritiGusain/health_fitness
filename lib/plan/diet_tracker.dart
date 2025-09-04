import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/shared_preferences.dart';

//import '/rounded_circular_progress.dart'; // <-- your custom progress file
import 'package:test_app/utils/circlular progressbar.dart';
import 'package:test_app/utils/custom_checkbox.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  Map<String, dynamic>? dietData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDietData();
  }

  Future<void> fetchDietData() async {
    setState(() => isLoading = true);
    try {
      // 🔹 Call global ApiService
      final data = await ApiService.getRequest("user/");
      setState(() {
        dietData = data['current_diet']; // store current_diet
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching diet data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dietData == null) {
      return const Center(child: Text("No diet data available"));
    } 

    // Extract meals
    final meals = dietData!['meals'] ?? {};
    final breakfast = meals['breakfast'];
    final lunch = meals['lunch'];
    final dinner = meals['dinner'];

    final macros = dietData!['macros'] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Diet"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Macronutrient Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Macronutrient Breakdown",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      RoundedCircularProgress(
                        progress:
                            (macros['protein_grams'] ?? 0) /
                            ((macros['protein_grams'] ?? 1) + 1), // example
                        remainingText:
                            "${dietData!['daily_calories']} Kcal\nRemaining",
                      ),
                      Text(
                        "${dietData!['daily_calories']} Kcal\nRemaining",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MacroStat(
                        label: "Carbs",
                        value:
                            "${macros['carbs_grams'] ?? 0}/${macros['carbs_grams'] ?? 1}g",
                      ),
                      _MacroStat(
                        label: "Protein",
                        value:
                            "${macros['protein_grams'] ?? 0}/${macros['protein_grams'] ?? 1}g",
                      ),
                      _MacroStat(
                        label: "Fat",
                        value:
                            "${macros['fats_grams'] ?? 0}/${macros['fats_grams'] ?? 1}g",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ask Luna button
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
                children: const [
                  Expanded(
                    child: Text(
                      "💬 Ask Luna to modify or change your plan",
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

            const SizedBox(height: 20),
            const Text(
              "Today's Plan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Meals
            if (breakfast != null) ...[
              const Text(
                "Breakfast",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              MealCardDynamic(meal: breakfast),
            ],
            if (lunch != null) ...[
              const SizedBox(height: 16),
              const Text(
                "Lunch",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              MealCardDynamic(meal: lunch),
            ],
            if (dinner != null) ...[
              const SizedBox(height: 16),
              const Text(
                "Dinner",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              MealCardDynamic(meal: dinner),
            ],
          ],
        ),
      ),
    );
  }
}

// Reusable MacroStat Widget
class _MacroStat extends StatelessWidget {
  final String label;
  final String value;

  const _MacroStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // Example: extract numbers like "54/76g"
    final parts = value.replaceAll("g", "").split("/");
    final consumed = double.tryParse(parts[0]) ?? 0;
    final total = double.tryParse(parts[1]) ?? 1;
    final progress = (consumed / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),

        // 🔹 Progress bar
        SizedBox(
          width: 50, // fixed minimum length like in your image
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: _getColor(label),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  // 🔹 Different color for each macro
  Color _getColor(String label) {
    switch (label.toLowerCase()) {
      case "carbs":
        return Color(0xFFA26A55);
      case "protein":
        return Color(0xFFB5282B);
      case "fat":
        return Color(0xFFE7B900);
      default:
        return Colors.green;
    }
  }
}

// Reusable Meal Card
class MealCardDynamic extends StatefulWidget {
  final Map<String, dynamic> meal;
  const MealCardDynamic({super.key, required this.meal});

  @override
  State<MealCardDynamic> createState() => _MealCardDynamicState();
}

class _MealCardDynamicState extends State<MealCardDynamic> {
  bool isChecked = false;

  void _showMealDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealDetailsBottomSheetDynamic(meal: widget.meal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                meal['name'] ?? "Meal",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.fastfood)),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'] ?? "",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 16),
                    const SizedBox(width: 4),
                    Text("${meal['calories'] ?? 0} Kcal"),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => _showMealDetailsBottomSheet(context),
                child: const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Checkbox(
                value: isChecked,
                onChanged: (val) {
                  setState(() {
                    isChecked = val ?? false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 🔹 Bottom Sheet Widget - exactly matching your image
class MealDetailsBottomSheetDynamic extends StatelessWidget {
  final Map<String, dynamic> meal;
  const MealDetailsBottomSheetDynamic({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final ingredients = meal['ingredients'] ?? [];
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                meal['name'] ?? "Meal",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return _IngredientRow(
                    ingredient: ingredients[index],
                    quantity: "", // API doesn’t have quantity
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// 🔹 Ingredient Row Widget - exactly matching your image
class _IngredientRow extends StatelessWidget {
  final String ingredient;
  final String quantity;

  const _IngredientRow({
    super.key,
    required this.ingredient,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          // 🔹 Bullet point - small black dot
          Container(
            width: 3,
            height: 3,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),

          // 🔹 Ingredient text
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                height: 1.3,
              ),
            ),
          ),

          // 🔹 Quantity
          Text(
            quantity,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
