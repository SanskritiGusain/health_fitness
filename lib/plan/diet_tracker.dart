import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import '/rounded_circular_progress.dart'; // <-- your custom progress file
import 'package:test_app/utils/circlular progressbar.dart';
import 'package:test_app/utils/custom_checkbox.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Custom Circular Progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const RoundedCircularProgress(
                        progress: 0.6,
                        remainingText: "400 Kcal\nRemaining",
                      ),
                      const Text(
                        "400 Kcal\nRemaining",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Macronutrient stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _MacroStat(label: "Carbs", value: "54/76g"),
                      _MacroStat(label: "Protein", value: "12/18g"),
                      _MacroStat(label: "Fat", value: "14/19g"),
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
                children: [
                  const Expanded(
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

            // Breakfast
            const Text("Breakfast", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const MealCard(),

            const SizedBox(height: 16),
            const Text("Lunch", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const MealCard(),

            const SizedBox(height: 16),
            const Text("Dinner", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const MealCard(),
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

  const _MacroStat({
    super.key,
    required this.label,
    required this.value,
  });

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
class MealCard extends StatefulWidget {
  const MealCard({super.key});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  bool isChecked = false; // <-- checkbox state

  // 🔹 Show bottom sheet when calendar is clicked
  void _showMealDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MealDetailsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Left side: Title + Image
          Column(
            children: [
              const Text(
                "4 Bean Chilli",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons_update/besan.svg",
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // 🔹 Right side: Meal Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text("Gram Flour Pancake",
                    style: TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons_update/mdi_fire.svg",
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text("360 Kcal"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons_update/carbs.svg",
                            height: 14),
                        const SizedBox(width: 4),
                        const Text("C: 20gm",
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons_update/protein.svg",
                            height: 14),
                        const SizedBox(width: 4),
                        const Text("P: 20gm",
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons_update/fat.svg",
                            height: 14),
                        const SizedBox(width: 4),
                        const Text("F: 10gm",
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Calendar + Checkbox
          Row(
            children: [
              GestureDetector(
                onTap: () => _showMealDetailsBottomSheet(context),
                child: const Icon(Icons.calendar_today,
                    size: 16, color: Colors.black),
              ),
              const SizedBox(width: 12),
              CustomSvgCheckbox(
                value: isChecked,
                onChanged: (newValue) {
                  setState(() {
                    isChecked = newValue ?? false;
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
class MealDetailsBottomSheet extends StatelessWidget {
  const MealDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          // 🔹 Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 🔹 Header with title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Besan Chilla",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // 🔹 Ingredients header
    Padding(
  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
  child: Row(
    children: [
      SvgPicture.asset(
        "assets/icons_update/incredient.svg", // your image path
        width: 20,
        height: 20,
      ),
      const SizedBox(width: 8), // space between image & text
      const Text(
        "Ingredients",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    ],
  ),
),


          // 🔹 Ingredients List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  _IngredientRow(ingredient: "Gram flour", quantity: "1 cup"),
                  _IngredientRow(ingredient: "Onion (finely chopped)", quantity: "1 medium"),
                  _IngredientRow(ingredient: "Tomato (finely chopped)", quantity: "1 medium"),
                  _IngredientRow(ingredient: "Green chili (chopped)", quantity: "2"),
                  _IngredientRow(ingredient: "Coriander leaves (chopped)", quantity: "2 tbsp"),
                  _IngredientRow(ingredient: "Ginger-garlic paste", quantity: "1 tsp"),
                  _IngredientRow(ingredient: "Turmeric powder", quantity: "1/2 tsp"),
                  _IngredientRow(ingredient: "Red chili powder", quantity: "1/2 tsp"),
                  _IngredientRow(ingredient: "Salt", quantity: "to taste"),
                  _IngredientRow(ingredient: "Water", quantity: "as needed"),
                  _IngredientRow(ingredient: "Oil", quantity: "for cooking"),
                ],
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