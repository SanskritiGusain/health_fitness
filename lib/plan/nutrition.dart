// nutrition_screen.dart
import 'package:flutter/material.dart';

// ----------- Data Models -----------
class Macronutrient {
  final String name;
  final int consumed;
  final int total;

  Macronutrient({
    required this.name,
    required this.consumed,
    required this.total,
  });
}

class Meal {
  final String name;
  final String subtitle;
  final int kcal;
  final int carbs;
  final int protein;
  final int fat;
  final String image;

  Meal({
    required this.name,
    required this.subtitle,
    required this.kcal,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.image,
  });
}

// ----------- Main Screen -----------
class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data (In future from API)
    final macronutrients = [
      Macronutrient(name: "Carbs", consumed: 14, total: 196),
      Macronutrient(name: "Protein", consumed: 14, total: 196),
      Macronutrient(name: "Fat", consumed: 14, total: 196),
    ];

    final breakfast = Meal(
      name: "4 Besan Chilla",
      subtitle: "Gram Flour Pancake",
      kcal: 360,
      carbs: 26,
      protein: 200,
      fat: 50,
      image: "assets/icons/besan_chilla.png", // Add asset in pubspec.yaml
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Nutrition"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MacronutrientBreakdownSection(
              remainingKcal: 400,
              macronutrients: macronutrients,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xFFF2EBB2),
                    Color(0xFFA3E2B8),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                ),

                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      "💬 Ask Luna to modify or change your plan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Today's Plan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            MealSection(title: "Breakfast", meal: breakfast),
            MealSection(title: "Lunch", meal: breakfast),
            MealSection(title: "Dinner", meal: breakfast),
          ],
        ),
      ),
    );
  }
}

// ----------- Macronutrient Breakdown Widget -----------
class MacronutrientBreakdownSection extends StatelessWidget {
  final int remainingKcal;
  final List<Macronutrient> macronutrients;

  const MacronutrientBreakdownSection({
    super.key,
    required this.remainingKcal,
    required this.macronutrients,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          // Circular progress (Dummy: fixed 50% progress)
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.5,
                  strokeWidth: 8,
                  color: Colors.green,
                  backgroundColor: Colors.grey.shade300,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$remainingKcal Kcal",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Remaining",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                macronutrients.map((m) {
                  return Column(
                    children: [
                      Text(
                        m.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${m.consumed}/${m.total}g",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

// ----------- Meal Section Widget -----------
class MealSection extends StatelessWidget {
  final String title;
  final Meal meal;

  const MealSection({super.key, required this.title, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (Name) and Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side: meal name + quantity
                  Row(
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "(100gm per)", // Replace with actual quantity
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  // Right side: calendar icon + checkbox
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/icons/calender.png",
                          height: 24,
                          width: 24,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 2),
                      Checkbox(value: false, onChanged: (val) {}),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),
              // Row: Image (Left) + Info (Right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      meal.image,
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
                        // Subtitle
                        Text(
                          meal.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Calories with Icon
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/mdi_fire.png", // Replace with your calorie icon asset
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${meal.kcal} Kcal",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // C, P, F Row with Icons
                        Row(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/carbohydrate.png",
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "C: ${meal.carbs}g",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/protein.png",
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "P: ${meal.protein}g",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/fiber.png",
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "F: ${meal.fat}g",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions Column
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
